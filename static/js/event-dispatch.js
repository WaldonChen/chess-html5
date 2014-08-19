Function.prototype.define=function(def){
    this.prototype=def;
    return this;
};

var EventDispatcher=function(target){
    this._target=target;
}.define({
    _target:null,
    _events:{},

    addEventListener:function(type,handle){
        if (!this._checkFunction(handle)) {
            return;
        }
        var evts=this._events;
        !evts[type] && (evts[type]=[]);
        evts[type].push(handle);
    },

    removeEventListener:function(type,handle){
        var evts=this._events[type];
        if (!this._checkFunction(handle) || !evts || !evts.length) {
            return;
        }
        for(var i=evts.length-1;i>=0;i--){
            evts[i]==handle && evts.splice(i,1);
        }
    },

    dispatchEvent:function(type){
        var evts=this._events[type];
        if (!evts || !evts.length) {
            return;
        }
        var args=Array.prototype.slice.call(arguments,0);
        args.shift();
        for(var i=0,l=evts.length;i<l;i++){
            evts[i].apply(this._target,args);
        }
    },

    _checkFunction:function(func){
        return String.prototype.slice.call(func, 0, 8) == "function";
    }
});
/*
var Counter=function(){
    this._eventDispatcher=new EventDispatcher(this);
}.define({
    n:0,
    _eventDispatcher:null,

    addEventListener:function(type,handle){
        this._eventDispatcher.addEventListener(type,handle);
    },
    removeEventListener:function(type,handle){
        this._eventDispatcher.removeEventListener(type,handle);
    },
    set:function(n){
        this.n=n;
        n%10==0 && this._eventDispatcher.dispatchEvent("ten","lalalalal~~");
    }
});
*/
