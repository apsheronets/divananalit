
open Common
open ExtLib
open Printf

let lines file =
  let chan = open_in file in
  Stream.from
    (fun _ ->
      try Some (input_line chan)
      with End_of_file -> close_in chan; None)

let fill_bitcoin_blocks_hash hash from_file =
  Stream.iter
    (fun l ->
      try
        let l = String.nsplit l " " in
        let block_number = int_of_string (List.nth l 0) in
        let date = List.nth l 1 in
        let difficulty = float_of_string (List.nth l 4) in
        Hashtbl.add hash date (block_number, difficulty)
      with e -> Printf.eprintf "this is a bullshit not a bitcoin block data: %s\n" (Printexc.to_string e)
    )
    (lines from_file)

let fill_litecoin_blocks_hash hash from_file =
  Stream.iter
    (fun l ->
      try
        let l = String.nsplit l " " in
        let block_number = int_of_string (List.nth l 0) in
        let date = List.nth l 1 in
        let difficulty = float_of_string (List.nth l 2) in
        Hashtbl.add hash date (block_number, difficulty)
      with e -> Printf.eprintf "this is a bullshit not a litecoin block data: %S: %s\n" l (Printexc.to_string e)
    )
    (lines from_file)

let profitability coins_type market_rates_file blocks_file energy_cost hashrate power =

  let blocks_hash = Hashtbl.create 50000 in

  let () =
    match coins_type with
    | Bitcoin  -> fill_bitcoin_blocks_hash blocks_hash blocks_file
    | Litecoin -> fill_litecoin_blocks_hash blocks_hash blocks_file in

  let market_rates =
    let lines = lines market_rates_file in
    Stream.from
      (fun _ ->
        try
          let line = Stream.next lines in
          (try
            let l = String.nsplit line " " in
            let date = List.nth l 0 in
            let market_rate = float_of_string (List.nth l 4) in
            Some (date, market_rate)
          with
            | e -> failwith (Printf.sprintf "this is a bullshit not a market rate data: %S: %s" line (Printexc.to_string e)))
        with
        | Stream.Failure -> None) in

  let reward_for_block =
    match coins_type with
    | Bitcoin -> reward_for_bitcoin_block
    | Litecoin -> reward_for_litecoin_block in

  let compile_line date market_rate =
    let block_number, difficulty =
      try
        Hashtbl.find blocks_hash date
      with Not_found ->
        failwith (Printf.sprintf "can't find block for %s" date) in
    let reward = reward_for_block block_number in
    let income_per_day = income_per_day market_rate reward difficulty hashrate power energy_cost in
    sprintf "%s %f" date income_per_day in

  let compiled_lines =
    Stream.from
      (fun _ ->
        let rec next () =
          try
            let date, market_rate = Stream.next market_rates in
            Some (compile_line date market_rate)
          with
            | Stream.Failure -> None
            | e ->
                Printf.eprintf "line compilation failed: %s\n" (Printexc.to_string e); next () in
        next ()) in

  compiled_lines

let self_cost f coins_type blocks_file energy_cost hashrate power =

  let blocks =
    let lines = lines blocks_file in
    Stream.from
      (fun _ ->
        try
          let l = Stream.next lines in
          let l = String.nsplit l " " in
          let block_number = int_of_string (List.nth l 0) in
          let date = List.nth l 1 in
          let difficulty =
            match coins_type with
            | Bitcoin -> float_of_string (List.nth l 4)
            | Litecoin -> float_of_string (List.nth l 2) in
          Some (date, block_number, difficulty)
        with
          Stream.Failure -> None) in

  let reward_for_block =
    match coins_type with
    | Bitcoin -> reward_for_bitcoin_block
    | Litecoin -> reward_for_litecoin_block in

  let compile date block_number difficulty =
    let reward = reward_for_block block_number in
    let course = f reward difficulty hashrate power energy_cost in
    sprintf "%s %f" date course in

  let compiled_lines =
    Stream.from
      (fun _ ->
        let rec next () =
          try
            let date, block_number, difficulty = Stream.next blocks in
            Some (compile date block_number difficulty)
          with
            | Stream.Failure -> None
            | e -> Printf.eprintf "line compilation failed: %s\n" (Printexc.to_string e); next () in
        next ()) in

  compiled_lines

let amortized_self_cost time hardware_cost = self_cost (amortizated_course time hardware_cost)
let self_cost = self_cost course

let (>>) f g = g f

let recoupment difficulty =
  let price weekly_difficulty_rise x =
    (((1. -. (1. -. weekly_difficulty_rise)) *. (difficulty /. (2. ** 32.))) /. x)
    *. (60. *. 60. *. 24. *. 14.) in
  for x = 1 to 5000 do
    [0.05; 0.15; 0.25] >> List.map (fun weekly_difficulty_rise ->
      price weekly_difficulty_rise (float_of_int x)
    ) >> fun results ->
    let results = String.concat " " (List.map string_of_float results) in
    printf "%d %s\n" x results
  done

type graph_types =
  | SelfCost
  | AmortizedSelfCost of float
  | Profitability
  | Recoupment

let () =

  let help = "FIXME" in

  let graph_type    = ref None in
  let energy_cost   = ref None in
  let hardware_cost = ref None in
  let hashrate      = ref None in
  let difficulty = ref 0. in
  let power = ref 0. in
  let block_data = ref "" in
  let market_rate_data = ref "" in
  let coins_type = ref None in

  let l = [
    "-coins-type",
      Arg.String (fun s -> coins_type := match s with "bitcoins" -> Some Bitcoin | "litecoins" -> Some Litecoin | _ -> assert false),
      "";
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
    "-market-rate-data",
      Arg.Set_string market_rate_data,
      "";
    "-mining-hardware-recoupment",
      Arg.Unit (fun () -> graph_type := Some Recoupment),
      "";
    "-difficulty",
      Arg.Set_float difficulty,
      "";
  ] in
  Arg.parse l (fun _ -> raise (Arg.Bad help)) help;

  match !graph_type with
  | None -> assert false
  | Some Profitability ->
      let coins_type =
        match !coins_type with
        | None -> assert false
        | Some x -> x in
      let market_rate_data =
        match !market_rate_data with
        | "" -> assert false
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
      let compiled_lines =
        profitability coins_type market_rate_data block_data energy_cost hashrate power in
      Stream.iter (print_endline) compiled_lines
  | Some SelfCost ->
      let coins_type =
        match !coins_type with
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
      let compiled_lines =
        self_cost coins_type block_data energy_cost hashrate power in
      Stream.iter (print_endline) compiled_lines
  | Some (AmortizedSelfCost time) ->
      let coins_type =
        match !coins_type with
        | None -> assert false
        | Some x -> x in        let hardware_cost =
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
      let compiled_lines =
        amortized_self_cost time hardware_cost coins_type block_data energy_cost hashrate power in
      Stream.iter (print_endline) compiled_lines
  | Some Recoupment ->
      let difficulty = !difficulty in
      recoupment difficulty

