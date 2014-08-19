Function.prototype.define=function(def){
    this.prototype=def;
    return this;
};

var moving_chess_man = null;

var ChessMan = function(){
}.define({
    party: null,
    role: null,
    x: 0,
    y: 0,
    context: null,
    loaded: false,
    image: null,
    EVENT_CLICKED: "clicked",
    moving: false,


    set: function(party, role, x, y) {
        this.x = x;
        this.y = y;
        this.party = party;
        this.role = role;
    }
});
