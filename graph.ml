
open Common
open ExtLib
open Printf

let lines =
  Stream.from
    (fun _ ->
      try Some (read_line ())
      with End_of_file -> None)

let compiled_lines =
  Stream.from
    (fun _ ->
      try
        let l = Stream.next lines in
        let l = String.nsplit l " " in
        let date = List.nth l 1 in
        let difficulty = float_of_string (List.nth l 4) in
        let course = course bitcoin_reward difficulty 650000000. 250. 4.
        and amortizated_course = amortizated_course 400. bitcoin_reward difficulty 650000000. 250. 4.
        and asics_course = course bitcoin_reward difficulty 60000000000. 620. 4.
        and asics_course_amortizated = amortizated_course 1499. bitcoin_reward difficulty 60000000000. 620. 4. in
        Some (sprintf "%s %f %f %f %f" date course amortizated_course asics_course asics_course_amortizated)
      with Stream.Failure -> None)

let () =
  Stream.iter (print_endline) compiled_lines
