
open Common
open ExtLib
open Printf

let lines file =
  let chan = open_in file in
  Stream.from
    (fun _ ->
      try Some (input_line chan)
      with End_of_file -> close_in chan; None)

let blocks_hash = Hashtbl.create 2000

let fill_blocks_hash () =
  Stream.iter
    (fun l ->
      let l = String.nsplit l " " in
      let block_number = int_of_string (List.nth l 0) in
      let date = List.nth l 1 in
      let difficulty = float_of_string (List.nth l 4) in
      Hashtbl.add blocks_hash date (block_number, difficulty)
    )
    (lines "data/bitcoin-blocks.dat")

let () = fill_blocks_hash ()

let lines = lines "data/mtgox-btc-usd.dat"

let compile l =
  let l = String.nsplit l " " in
  let date = List.nth l 0 in
  let market_rate = float_of_string (List.nth l 4) in
  let block_number, difficulty = Hashtbl.find blocks_hash date in
  let reward = reward_for_bitcoin_block block_number in
  let power_rate = 4. in
  let income_per_day hashrate power = income_per_day market_rate reward difficulty hashrate power power_rate in
  let core_i7_950_income = income_per_day 18900000. 150. in
  let video7970_income   = income_per_day 650000000. 250. in
  let avalon2_income     = income_per_day 60000000000. 620. in
  sprintf "%s %f %f %f %f" date difficulty core_i7_950_income video7970_income avalon2_income

let compiled_lines =
  Stream.from
    (fun _ ->
      try
        let l = Stream.next lines in
        Some (compile l)
      with Stream.Failure -> None)

let () =
  Stream.iter (print_endline) compiled_lines
