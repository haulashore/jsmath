// Generated by CoffeeScript 1.3.3
(function() {
  var Operators;

  Operators = (function() {

    function Operators() {
      window._$_ = PaperScript._$_;
      window.$_ = PaperScript.$_;
      this.basicOps = [["add", "add"], ["sub", "subtract"], ["mul", "multiply"], ["div", "divide"]];
      this.ops = this.basicOps.concat([["mod", "modulo"], ["eq", "equals"], ["lt", "lt"], ["gt", "gt"], ["leq", "leq"], ["geq", "geq"]]);
      this.assignOps = ["addeq", "subeq", "muleq", "diveq", "modeq"];
      this.arrayOverloads();
      this.complexOverloads();
    }

    Operators.prototype.arrayOverloads = function() {
      var A, a, b, nm, op, overloadOperator, setMethod, setMethodScalar, setUnaryMethod, _i, _j, _len, _len1, _ref, _ref1;
      A = Array.prototype;
      nm = numeric;
      A.size = function() {
        return [this.length, this[0].length];
      };
      setMethod = function(op) {
        return A[op] = function(y) {
          return nm[op](this, y);
        };
      };
      setUnaryMethod = function(op) {
        return A[op] = function() {
          return nm[op](this);
        };
      };
      setMethodScalar = function(op) {
        return Number.prototype[op] = function(y) {
          return nm[op](+this, y);
        };
      };
      overloadOperator = function(proto, a, b) {
        return proto["__" + b] = proto[a];
      };
      _ref = this.ops;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        op = _ref[_i];
        a = op[0], b = op[1];
        setMethod(a);
        setMethodScalar(a);
        overloadOperator(A, a, b);
        overloadOperator(Number.prototype, a, b);
      }
      _ref1 = this.assignOps;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        op = _ref1[_j];
        setMethod(op);
      }
      setMethod("dot");
      setUnaryMethod("neg");
      overloadOperator(A, "neg", "negate");
      setUnaryMethod("clone");
      setUnaryMethod("sum");
      A.transpose = function() {
        return nm.transpose(this);
      };
      return Object.defineProperty(A, 'T', {
        get: function() {
          return this.transpose();
        }
      });
    };

    Operators.prototype.complexOverloads = function() {
      var numericOld, op, proto, set, _i, _len, _ref;
      proto = numeric.T.prototype;
      proto.size = function() {
        return [this.x.length, this.x[0].length];
      };
      numeric.complex = function(x, y) {
        if (y == null) {
          y = 0;
        }
        return new numeric.T(x, y);
      };
      numericOld = {};
      set = function(op, op1) {
        proto["__" + op1] = proto[op];
        numericOld[op] = numeric[op];
        return numeric[op] = function(x, y) {
          if (typeof x === "number" && y instanceof numeric.T) {
            return numeric.complex(x)[op](y);
          } else {
            return numericOld[op](x, y);
          }
        };
      };
      _ref = this.basicOps;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        op = _ref[_i];
        set(op[0], op[1]);
      }
      proto.__negate = proto.neg;
      Object.defineProperty(proto, 'T', {
        get: function() {
          return this.transpose();
        }
      });
      return Object.defineProperty(proto, 'H', {
        get: function() {
          return this.transjugate();
        }
      });
    };

    return Operators;

  })();

  window.Operators = Operators;

}).call(this);
