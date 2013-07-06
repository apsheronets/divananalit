
open Common
open ExtLib
open Printf

let lines =
  Stream.from
    (fun _ ->
      try Some (read_line ())
      with End_of_file -> None)

let compile l =
  let l = String.nsplit l " " in
  let block_number = int_of_string (List.nth l 0) in
  let date = List.nth l 1 in
  let difficulty = float_of_string (List.nth l 4) in
  let reward = reward_for_bitcoin_block block_number in
  let course = course reward difficulty 650000000. 250. 4.
  and amortizated_course = amortizated_course 400. reward difficulty 650000000. 250. 4.
  and asics_course = course reward difficulty 60000000000. 620. 4.
  and asics_course_amortizated = amortizated_course 1499. reward difficulty 60000000000. 620. 4. in
  sprintf "%s %f %f %f %f" date course amortizated_course asics_course asics_course_amortizated

let compiled_lines =
  Stream.from
    (fun _ ->
      try
        let l = Stream.next lines in
        Some (compile l)
      with Stream.Failure -> None)

let () =
  Stream.iter (print_endline) compiled_lines
