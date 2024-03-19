import Int "mo:base/Int";
import TrieMap "mo:base/TrieMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import _HashMap "mo:base/HashMap";
import Result "mo:base/Result"; // Importing the Result module

actor FarmerMarket {

  type Farmer = {
    id : Text;
    name : Text;
    produce : Text;
    quantity : Nat;
    price : Nat;
    verified : Bool;
    timestamp : Int;
    accessLevel : AccessLevel; // Adding the accessLevel field
  };

  type AccessLevel = {
    #ADMIN;
    #USER;
    #GUEST;
  };

  var farmers = TrieMap.TrieMap<Text, Farmer>(Text.equal, Text.hash);
  stable var farmerEntries: [(Text, Farmer)] = [];

  system func preupgrade() {
    farmerEntries := Iter.toArray(farmers.entries());
  };

  system func postupgrade() {
    farmers := TrieMap.fromEntries(farmerEntries.vals(), Text.equal, Text.hash);
  };

  public shared func registerFarmer(args : Farmer) : async () {
    farmers.put(args.id, args);
  };

  public shared query func getFarmer(id : Text) : async Result.Result<Farmer, Text> {
    switch (farmers.get(id)) {
      case (null) {
        return #err("Farmer not found");
      };
      case (?farmer) {
        return #ok(farmer);
      };
    };
  };

  public shared func updateFarmer(args : Farmer) : async () {
    farmers.put(args.id, args);
  };

  public shared func deleteFarmer(id : Text) : async () {
    farmers.delete(id);
  };

  public shared query func getAllFarmers() : async [Farmer] {
    Iter.toArray(farmers.vals());
  };

  public shared query func getFarmerAccessLevel(id : Text) : async Result.Result<Text, Text> {
    switch (farmers.get(id)) {
      case (null) {
        return #err("Farmer not found");
      };
      case (?farmer) {
        switch (farmer.accessLevel) {
          case (#ADMIN) {
            return #ok("You are an ADMIN");
          };
          case (#USER) {
            return #ok("You are just a USER");
          };
          case (#GUEST) {
            return #ok("You are a GUEST");
          };
        };
      };
    };
  };
  };