
open Common
open ExtLib
open Printf

let lines file =
  let chan = open_in file in
  Stream.from
    (fun _ ->
      try Some (input_line chan)
      with End_of_file -> close_in chan; None)

let fill_blocks_hash hash from_file =
  Stream.iter
    (fun l ->
      let l = String.nsplit l " " in
      let block_number = int_of_string (List.nth l 0) in
      let date = List.nth l 1 in
      let difficulty = float_of_string (List.nth l 4) in
      Hashtbl.add hash date (block_number, difficulty)
    )
    (lines from_file)

let profitability ?(bitcoins = true) mtgox_market_rates_file blocks_file energy_cost hashrate power =

  let blocks_hash = Hashtbl.create 2000 in
  fill_blocks_hash blocks_hash blocks_file;

  let mtgox_market_rates =
    let lines = lines mtgox_market_rates_file in
    Stream.from
      (fun _ ->
        try
          let line = Stream.next lines in
          let l = String.nsplit line " " in
          let date = List.nth l 0 in
          let market_rate = float_of_string (List.nth l 4) in
          Some (date, market_rate)
        with
           Stream.Failure -> None) in

  let reward_for_block =
    if bitcoins
    then reward_for_bitcoin_block
    else fun _ -> 50. in

  let compile_line date market_rate =
    let block_number, difficulty = Hashtbl.find blocks_hash date in
    let reward = reward_for_block block_number in
    let income_per_day hashrate power = income_per_day market_rate reward difficulty hashrate power energy_cost in
    let income = income_per_day hashrate power in
    sprintf "%s %f" date income in

  let compiled_lines =
    Stream.from
      (fun _ ->
        try
          let date, market_rate = Stream.next mtgox_market_rates in
          Some (compile_line date market_rate)
        with Stream.Failure -> None) in

  compiled_lines

let self_cost f ?(bitcoins = true) blocks_file energy_cost hashrate power =

  let blocks =
    let lines = lines blocks_file in
    Stream.from
      (fun _ ->
        try
          let l = Stream.next lines in
          let l = String.nsplit l " " in
          let block_number = int_of_string (List.nth l 0) in
          let date = List.nth l 1 in
          let difficulty = float_of_string (List.nth l 4) in
          Some (date, block_number, difficulty)
        with
          Stream.Failure -> None) in

  let reward_for_block =
    if bitcoins
    then reward_for_bitcoin_block
    else fun _ -> 50. in

  let compile date block_number difficulty =
    let reward = reward_for_block block_number in
    let course = f reward difficulty hashrate power energy_cost in
    sprintf "%s %f" date course in

  let compiled_lines =
    Stream.from
      (fun _ ->
        try
          let date, block_number, difficulty = Stream.next blocks in
          Some (compile date block_number difficulty)
        with Stream.Failure -> None) in

  compiled_lines

let amortized_self_cost time hardware_cost = self_cost (amortizated_course time hardware_cost)
let self_cost = self_cost course

type graph_types =
  | SelfCost
  | AmortizedSelfCost of float
  | Profitability

let () =

  let help = "FIXME" in

  let graph_type    = ref None in
  let energy_cost   = ref None in
  let hardware_cost = ref None in
  let hashrate      = ref None in
  let power = ref 0. in
  let block_data = ref "" in
  let mtgox_data = ref "" in
  let btce_data  = ref "" in
  let bitcoins = ref true in

  let l = [
    "-self-cost",
      Arg.Unit (fun () -> graph_type := Some SelfCost),
      "";
    "-amortized-self-cost",
      Arg.Float (fun i -> graph_type := Some (AmortizedSelfCost i)),
      "";
    "-profitability",
      Arg.Unit (fun () -> graph_type := Some Profitability),
      "";
    "-energy-cost",
      Arg.Float (fun i -> energy_cost := Some i),
      "";
    "-hardware-cost",
      Arg.Float (fun i -> hardware_cost := Some i),
      "";
    "-hashrate",
      Arg.Float (fun f -> hashrate := Some f),
      "";
    "-power",
      Arg.Set_float power,
      "";
    "-blocks-data",
      Arg.Set_string block_data,
      "";
    "-mtgox-data",
      Arg.Set_string mtgox_data,
      "";
    "-btce-data",
      Arg.Set_string btce_data,
      "";
    "-litecoins",
      Arg.Clear bitcoins,
      "";
  ] in
  Arg.parse l (fun _ -> raise (Arg.Bad help)) help;

  let compiled_lines =
    match !graph_type with
    | None -> assert false
    | Some Profitability ->
        let mtgox_data =
          match !mtgox_data with
          | "" ->
              (match !btce_data with
              | "" -> assert false
              | x -> bitcoins := false; x)
          | x -> x in
        let block_data =
          match !block_data with
          | "" -> assert false
          | x -> x in
        let energy_cost =
          match !energy_cost with
          | Some x -> x
          | None -> assert false in
        let hashrate =
          match !hashrate with
          | Some x -> x
          | None -> assert false in
        let power = !power in
        profitability ~bitcoins:!bitcoins mtgox_data block_data energy_cost hashrate power
    | Some SelfCost ->
        let block_data =
          match !block_data with
          | "" -> assert false
          | x -> x in
        let energy_cost =
          match !energy_cost with
          | Some x -> x
          | None -> assert false in
        let hashrate =
          match !hashrate with
          | Some x -> x
          | None -> assert false in
        let power = !power in
        self_cost ~bitcoins:!bitcoins block_data energy_cost hashrate power
    | Some (AmortizedSelfCost time) ->
        let hardware_cost =
          match !hardware_cost with
          | None -> assert false
          | Some x -> x in
        let block_data =
          match !block_data with
          | "" -> assert false
          | x -> x in
        let energy_cost =
          match !energy_cost with
          | Some x -> x
          | None -> assert false in
        let hashrate =
          match !hashrate with
          | Some x -> x
          | None -> assert false in
        let power = !power in
        amortized_self_cost ~bitcoins:!bitcoins time hardware_cost block_data energy_cost hashrate power in

  Stream.iter (print_endline) compiled_lines

