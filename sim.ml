let () =
  let difficulty = 29829733124.04041672 in
  let days_before_adjust = 9. in
  let coins_income_per_day diff = Common.coins_income_per_day 25. diff 1000000000000. in
  let sim next_adjust_in days two_week_change =
    let rec loop diff acc rest =
      if rest <= 14.
      then acc +. ((coins_income_per_day diff) *. rest)
      else loop (diff *. two_week_change) (acc +. ((coins_income_per_day diff) *. 14.)) (rest -. 14.) in
    let acc = (coins_income_per_day difficulty) *. next_adjust_in in
    let rest = days -. next_adjust_in in
    let diff = difficulty *. two_week_change in
    loop diff acc rest in
  print_endline "Estimated \"true\" TH1 income for 90 days:";
  Printf.printf "if difficulty will get +30%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 1.30);
  Printf.printf "if difficulty will get +20%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 1.20);
  Printf.printf "if difficulty will get +15%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 1.15);
  Printf.printf "if difficulty will get +10%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 1.10);
  Printf.printf "if difficulty will get + 5%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 1.05);
  Printf.printf "if difficulty will get + 0%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 1.00);
  Printf.printf "if difficulty will get - 5%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 0.95);
  Printf.printf "if difficulty will get -10%% every adjust: %f BTC;\n" (sim days_before_adjust 90. 0.90);

(* let f p d = ((((p /. 100.) +. 1.) ** d) -. 1.) *. 100.;; *)
