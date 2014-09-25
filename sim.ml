let () =
  let difficulty = 34661425923.97693634 in
  let next_adjust_in = 14. in
  let days_left = 15. +. 30. +. 31. +. (30. -. 26.) in
  let coins_income_per_day diff = Common.coins_income_per_day 25. diff 1000000000000. in
  let sim two_week_change =
    let rec loop diff acc rest =
      if rest <= 14.
      then acc +. ((coins_income_per_day diff) *. rest)
      else loop (diff *. two_week_change) (acc +. ((coins_income_per_day diff) *. 14.)) (rest -. 14.) in
    let acc = (coins_income_per_day difficulty) *. next_adjust_in in
    let rest = days_left -. next_adjust_in in
    let diff = difficulty *. two_week_change in
    loop diff acc rest in
  Printf.printf "Estimated TH1 income (real value) for %.0f days:\n" days_left;
  Printf.printf "if difficulty will get +30%% every adjust: %f BTC;\n" (sim 1.30);
  Printf.printf "if difficulty will get +20%% every adjust: %f BTC;\n" (sim 1.20);
  Printf.printf "if difficulty will get +15%% every adjust: %f BTC;\n" (sim 1.15);
  Printf.printf "if difficulty will get +10%% every adjust: %f BTC;\n" (sim 1.10);
  Printf.printf "if difficulty will get + 5%% every adjust: %f BTC;\n" (sim 1.05);
  Printf.printf "if difficulty will get + 0%% every adjust: %f BTC;\n" (sim 1.00);
  Printf.printf "if difficulty will get - 5%% every adjust: %f BTC;\n" (sim 0.95);
  Printf.printf "if difficulty will get -10%% every adjust: %f BTC;\n" (sim 0.90);

(* let f p d = ((((p /. 100.) +. 1.) ** d) -. 1.) *. 100.;; *)
