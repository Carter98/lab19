(*
                Component Behaviors of an ATM Machine

The functions here represent the component behaviors that an ATM
machine can take, including: prompting for and acquiring from the
customer some information (choosing an action or entering an account
id or an amount); presenting information to the customer; dispensing
cash.

Implementation of these behaviors is likely to require some database
of accounts, each with an id number, a customer name, and a current
balance.
 *)

(* Customer account identifiers *)
type id = int

(* Possible actions that an ATM customer can perform *)
type action =
  | Balance           (* balance inquiry *)
  | Withdraw of int   (* withdraw an amount *)
  | Deposit of int    (* deposit an amount *)
  | Next              (* finish this customer and move on to the next one *)
  | Finished          (* shut down the ATM and exit entirely *)
;;

(*....................................................................
 Initializing database of accounts
*)

(* A specification of a customer name and initial balance for
   initializing the account database *)
type account_spec = {name : string; id : id; balance : int} ;;

(* initialize accts -- Establishes a database of accounts, each with a
   name, aribtrary id, and balance. The names and balances are
   initialized as per the `accts` provided. *)

module Account_set = Set.Make (struct
                                  type t = account_spec
                                  let compare acc1 acc2 = compare acc1.id acc2.id
                               end) ;;

let accounts = ref Account_set.empty ;;

let initialize (acc_list : account_spec list) : unit =
  accounts := (List.fold_left (fun s elt -> Account_set.add elt s) !accounts acc_list) ;;

(*....................................................................
 Acquiring information from the customer
*)

(* acquire_id () -- Requests from the ATM customer and returns an id
   (akin to entering one's ATM card), by prompting for an id number
   and reading an id from stdin. *)
let acquire_id () : id = Printf.printf "Enter customer id: ";
                         read_int () ;;

(* acquire_amount () -- Requests from the ATM customer and returns an
   amount by prompting for an amount and reading an int from stdin. *)
let acquire_amount () : int = Printf.printf "Enter amount : ";
                              read_int () ;;

(* acquire_act () -- Requests from the user and returns an action to
   be performed, as a value of type action *)
let rec acquire_act () : action =
  Printf.printf "Enter action: (B) Balance (-) Withdraw (+) Deposit (=) Done (X) Exit: ";
  let inp = read_line () in
  match inp with
  | "B" -> Balance
  | "+" -> Deposit (acquire_amount ())
  | "-" -> Withdraw (acquire_amount ())
  | "=" -> Next
  | "X" -> Finished
  | _ -> acquire_act () ;;

(*....................................................................
  Querying and updating the account database

  These functions all raise Not_found if there is no account with the
  given id.
 *)

(* get_balance id -- Returns the balance for the customer account with
   the given id. *)
let find_elt (ident : id) : account_spec =
  try Account_set.find { name = "test"; id = ident; balance = 0; } !accounts
  with _ -> raise Not_found;;

let get_balance (ident : id) : int =
  let elt = find_elt ident in
  elt.balance  ;;

(* get_name id -- Returns the name associated with the customer
   account with the given id. *)
let get_name (ident : id) : string =
  let elt = find_elt ident in
  elt.name ;;

(* update_balance id amount -- Modifies the balance of the customer
   account with the given id,setting it to the given amount. *)
let update_balance (ident: id) (balance : int) : unit =
  let accs, elt = !accounts, find_elt ident in
  let new_accs = accs |> Account_set.remove elt
    |> Account_set.add { name = elt.name; id = ident; balance = balance;} in
  accounts := new_accs ;;

(*....................................................................
  Presenting information and cash to the customer
 *)

(* present_message message -- Presents to the customer (on stdout) the
   given message followed by a newline. *)
let present_message (s: string) : unit =
  Printf.printf "%s\n" s ;;


(* deliver_cash amount -- Dispenses the given amount of cash to the
   customer (really just prints to stdout a message to that
   effect). *)
let deliver_cash (i: int) : unit =
  let rec bills (num: int) : string =
    if num - 100 >= 0 then
      "[100 @ 100]" ^ bills (num-100)
    else if num >= 50 then
      "[50 @ 50]" ^ bills (num-50)
    else if num - 20 > 0 then
      "[20 @ 20]" ^ bills (num-20)
    else "" in
  Printf.printf "%s and %d leftover\n" (bills i) ((i mod 50) mod 20);;
