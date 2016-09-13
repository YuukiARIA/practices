-module(calc).
-compile(export_all).

calculate(ExprText) ->
  case addsub(ExprText) of
    {ok, {Ast, _Rest}} -> eval_ast(Ast);
    _ -> {error}
  end.

eval_ast({ ast_add, X, Y }) -> eval_ast(X) + eval_ast(Y);
eval_ast({ ast_sub, X, Y }) -> eval_ast(X) - eval_ast(Y);
eval_ast({ ast_mul, X, Y }) -> eval_ast(X) * eval_ast(Y);
eval_ast({ ast_div, X, Y }) -> eval_ast(X) div eval_ast(Y);
eval_ast({ ast_mod, X, Y }) -> eval_ast(X) rem eval_ast(Y);
eval_ast({ ast_number, X }) -> X.

addsub(Text) ->
  case muldiv(Text) of
    {ok, {X, Rest}} -> addsub1(Rest, X);
    _ -> {error, addsub, Text}
  end.

addsub1(Text, X) ->
  case lex(Text) of
    {ok, {Type, _, Rest1}} ->
      case Type of
        op_add ->
          case muldiv(Rest1) of
            {ok, {Y, Rest2}} -> addsub1(Rest2, {ast_add, X, Y});
            _ -> {error, addsub1, 1, Text}
          end;
        op_sub ->
          case muldiv(Rest1) of
            {ok, {Y, Rest2}} -> addsub1(Rest2, {ast_sub, X, Y});
            _ -> {error, addsub1, 2, Text}
          end;
        _ -> {ok, {X, Text}}
      end;
    _ -> {error, addsub1, 3, Text}
  end.

muldiv(Text) ->
  case atomic(Text) of
    {ok, {X, Rest}} -> muldiv1(Rest, X);
    _ -> {error, Text}
  end.

muldiv1(Text, X) ->
  case lex(Text) of
    {ok, {Type, _, Rest1}} ->
      case Type of
        op_mul ->
          case atomic(Rest1) of
            {ok, {Y, Rest2}} -> muldiv1(Rest2, {ast_mul, X, Y});
            _ -> {error, muldiv1, Text}
          end;
        op_div ->
          case atomic(Rest1) of
            {ok, {Y, Rest2}} -> muldiv1(Rest2, {ast_div, X, Y});
            _ -> {error, muldiv1, Text}
          end;
        op_mod ->
          case atomic(Rest1) of
            {ok, {Y, Rest2}} -> muldiv1(Rest2, {ast_mod, X, Y});
            _ -> {error, muldiv1, Text}
          end;
        _ -> {ok, {X, Text}}
      end;
    _ -> {error, muldiv1, Text}
  end.

atomic(Text) ->
  case lex(Text) of
    {ok, {Type, Token, Rest}} ->
      case Type of
        number -> {ok, {{ast_number, list_to_integer(Token)}, Rest}};
        type_paren_l ->
          case addsub(Rest) of
            {ok, {Ast, Rest1}} ->
              case lex(Rest1) of
                {ok, {type_paren_r, _, Rest2}} -> {ok, {Ast, Rest2}};
                _ -> {error, "unclosed"}
              end;
            _ -> {error, "error after '('."}
          end;
        _ -> {error, atomic, Text}
      end;
    _ -> {error, atomic, Text}
  end.

lex(Text) ->
  S = skipws(Text),
  case length(S) of
    0 -> {ok, {'$end', '$$', []}};
    _ -> lex_non_empty(S)
  end.

lex_non_empty(Text) ->
  [C|CS] = skipws(Text),
  case type(C) of
    digit ->
      { TokenText, Rest } = lex_number(Text),
      {ok, {number, TokenText, Rest}};
    alpha ->
      { TokenText, Rest } = lex_name(Text),
      {ok, {name, TokenText, Rest}};
    other ->
      case C of
        $+ -> {ok, {op_add, "+", CS}};
        $- -> {ok, {op_sub, "-", CS}};
        $* -> {ok, {op_mul, "*", CS}};
        $/ -> {ok, {op_div, "/", CS}};
        $% -> {ok, {op_mod, "%", CS}};
        $( -> {ok, {type_paren_l, "(", CS}};
        $) -> {ok, {type_paren_r, ")", CS}};
        _ -> {error, C}
      end;
    _ -> {error, C}
  end.

lex_number(Text) -> lex_number(Text, []).

lex_number(Text, Result) ->
  case head_type(Text) of
    digit -> [C|CS] = Text, lex_number(CS, [C|Result]);
    _ -> { lists:reverse(Result), Text }
  end.

lex_name(Text) -> lex_name(Text, []).

lex_name(Text, Result) ->
  case head_type(Text) of
    alpha -> [C|CS] = Text, lex_name(CS, [C|Result]);
    _ -> { lists:reverse(Result), Text }
  end.

head_type([]) -> type_end;
head_type([C|_]) -> type(C).

type(C) ->
  if
    $0 =< C, C =< $9 -> digit;
    $a =< C, C =< $z; $A =< C, C =< $Z -> alpha;
    true -> other
  end
.

is_ws(C) -> C =:= $\s orelse C =:= $\t orelse C =:= $\n.

skipws([]) -> [];
skipws([C|CS]) ->
  case is_ws(C) of
    true  -> skipws(CS);
    false -> [C|CS]
  end
.

succ([]) -> [];
succ([C|CS]) -> [{C, CS}].

peek([C|_]) -> {C};
peek(_) -> {}.

peek2([C1, C2 | _]) -> {C1, C2};
peek2(_) -> {}.
