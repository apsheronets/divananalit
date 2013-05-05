(* 	$Id: ex1.ml,v 1.2 2004-07-30 19:45:32 chris_77 Exp $	 *)
(* From the Matlab plotting examples at
   http://www.indiana.edu/~statmath/math/matlab/plotting/
*)

module P = Gnuplot
open Parse_args

let course ?(reward=25.) difficulty hashrate power_cost =
  let time_in_seconds = difficulty *. (2. ** 32.) /. hashrate in
  ((time_in_seconds /. 3600.) *. power_cost) /. reward

let course power_cost = course 7672999.92016 400000000. (power_cost /. 30.)

(*let difficulty = 3000000.0*)
(*let hashrate = 400000000.*)
(*let power = 17.2*)
let revard = 25.
let time_for_revard difficulty hashrate = difficulty *. (2. ** 32.) /. hashrate
let to_usd x = x /. 30.
let energy_for_revard difficulty hashrate power = (time_for_revard difficulty hashrate) *. power
let energy_per_coin difficulty hashrate power = (energy_for_revard difficulty hashrate power) /. revard

let course difficulty hashrate power power_rate =
  (energy_per_coin difficulty hashrate power) *. (to_usd (power_rate /. 3600000.))

let proofit_per_second difficulty hashrate power power_rate =
  (25. *. course difficulty hashrate power power_rate) /.
  (time_for_revard difficulty hashrate)

let amortization_per_second hardware_cost =
  let years = 1. in
  hardware_cost /. (years *. 365. *. 24. *. 60. *. 60.)

let amortizated_course hardware_cost difficulty hashrate power power_rate =
  ((proofit_per_second difficulty hashrate power power_rate +. amortization_per_second hardware_cost) *. (time_for_revard difficulty hashrate)) /. 25.

let market_rate = 100.

let income difficulty hashrate power power_rate =
  let course = course difficulty hashrate power power_rate in
  let course = market_rate -. course in
  (25. *. course) /.
  (time_for_revard difficulty hashrate)

let income_per_day difficulty hashrate power power_rate =
  (income difficulty hashrate power power_rate) *. 60. *. 60. *. 24.

let amortizated_income hardware_cost difficulty hashrate power power_rate =
  let course = amortizated_course hardware_cost difficulty hashrate power power_rate in
  let course = market_rate -. course in
  (25. *. course) /.
  (time_for_revard difficulty hashrate)

let amortizated_income_per_day hardware_cost difficulty hashrate power power_rate =
  (amortizated_income hardware_cost difficulty hashrate power power_rate) *. 60. *. 60. *. 24.

(*let time_for_revard difficulty hashrate = difficulty *. (2. ** 32.) /. hashrate*)

let difficulty_for_hashrate hashrate =
  let time = 600. in (* ten minutes *)
  (hashrate *. time) /. (2. ** 32.)

(*let print_proofit =
  let market_course = 100. in
  let years = 1. in
  ((energy_per_coin hashrate power) *. (to_usd (power_rate /. 3600000.))) /.
  (time_for_revard hashrate power)*)

let red = 0xFF0000
let green = 0x00AA00
let blue = 0x0000FF

(*let () =
  let g = P.init ?offline:(offline 1) ~xsize:1000. ~ysize:600. (device 1) in
  P.box g;
  P.xy_file g "/home/komar/mtgox-all-time"*)

let difficulty = 10076292.88341872
let network_hashrate = 73650000000000.
let current_blocks_per_second = 153. /. 24. /. 60. /. 60.

let () =
  let g = P.init ?offline:(offline 1) ~xsize:800. ~ysize:600. (device 1) in
  P.box g;
  P.xlabel g "count of asics";
  P.ylabel g "income per day, $";

  let f x =
    let network_hashrate = network_hashrate +. (50000000000. *. x) in
    let difficulty = difficulty_for_hashrate network_hashrate in
    income_per_day difficulty 50000000000. 0. 3. in

  P.color g red;
  P.fx g f 0. 100000.;

  P.close g

(*let () =
  let g = P.init (*?offline:(offline 1) ~xsize:500. ~ysize:300.*) (device 1) in
  P.box g;
  P.xlabel g "watt-hour rate, rur";
  P.ylabel g "bitcoin price, $";

  (* BitForce SC 50 Gh/s *)
  P.color g green;
  P.fx g (course difficulty 50000000000. 100.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 2499. difficulty 50000000000. 100.) 0. 5.;

  (* BitForce SC 50 Gh/s when there will 40 000 of them *)
  (let network_hashrate = network_hashrate +. (50000000000. *. 40000.) in
  let difficulty = difficulty_for_hashrate network_hashrate in
  P.color g green;
  P.fx g (course difficulty 50000000000. 100.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 2499. difficulty 50000000000. 100.) 0. 5.);

  (* 7990 *)
  (*P.color g green;
  P.fx g (course 1200000000. 375.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 1200000000. 375. 777.) 0. 5.;

  (* 7750 *)
  P.color g green;
  P.fx g (course 123000000. 55.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 123000000. 55. 93.) 0. 5.;*)

  (* 7970 *)
  (*P.color g green;
  P.fx g (income_per_day 650000000. 250.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_income_per_day 399. 650000000. 250.) 0. 5.;*)

  (* 5770 *)
  (*P.color g green;
  P.fx g (income_per_day 200000000. 108.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_income_per_day 50. 200000000. 108.) 0. 5.;*)

  (* 7950 *)
  (*P.color g green;
  P.fx g (income_per_day 500000000. 200.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_income_per_day 399. 500000000. 200.) 0. 5.;*)

  (*P.color g green;
  P.fx ~label:"Avalon ASIC #2" g (course 60000000000. 620.) 0. 5.;
  P.color g red;
  P.fx ~label:"Avalon ASIC #2 amortizated" g (amortizated_course 60000000000. 620. 1299.) 0. 5.;*)

  (* 7990 *)
  (*P.color g green;
  P.fx g (income_per_day 1200000000. 375.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_income_per_day 777. 1200000000. 375.) 0. 5.;*)

  (*P.color g green;
  P.fx g (income_per_day 1500000000000. 0.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_income_per_day 0. 1500000000000. 0.) 0. 5.;*)

  (*P.color g green;
  P.fx g (income_per_day 60000000000. 620.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_income_per_day 1299. 60000000000. 620.) 0. 5.;*)

  (*P.color g green;
  P.fx g (income_per_day 1500000000000. 0.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_income_per_day 2499. 1500000000000. 0.) 0. 5.;*)

  (*P.color g green;
  P.fx g (course 60000000000. 620.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 60000000000. 620. 1299.) 0. 5.;*)

  (*P.color g green;
  P.fx g (course 400000000. 17.2) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 400000000. 17.2 550.) 0. 5.;

  P.color g green;
  P.fx g (course 212830000. 108.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 212830000. 108. 150.) 0. 5.;

  (* 7990 *)
  P.color g green;
  P.fx g (course 1200000000. 375.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 1200000000. 375. 777.) 0. 5.;

  P.color g green;
  P.fx g (course 123000000. 55.0) 0. 5.;*)

  P.close g
*)

(*let () =
  let g = P.init ?offline:(offline 1) ~xsize:500. ~ysize:300. (device 1) in
  P.box g;
  P.title g "sinus";
  P.color g red;
  P.fx g sin (-10.) 10.;
  P.close g

let () =
  let a = -6.
  and b = 6. in
  let g = P.init ?offline:(offline 2) (device 2) in
  P.env g a b (-2.) 2.;
  P.color g red;
  P.fx g cos a b;
  P.color g green;
  P.fx g (fun x -> 1. -. x**2. /. 2.) a b;
  P.color g blue;
  P.fx g (fun x -> 1. -. x**2. /. 2. +. x**4. /. 24.) a b;
  P.close g

let () =
  let g = P.init ?offline:(offline 3) (device 3) in
  P.box g;
  P.color g blue;
  P.xy_param g (fun t -> (t *. cos t, t *. sin t)) 0. 10.;
  P.close g*)
