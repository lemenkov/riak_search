%% -------------------------------------------------------------------
%%
%% Copyright (c) 2007-2010 Basho Technologies, Inc.  All Rights Reserved.
%%
%% -------------------------------------------------------------------

%%% @doc The scope operation tells Search to switch to a new index
%%% and/or field for all future operations.

-module(riak_search_op_scope).
-export([
         preplan/2,
         chain_op/4
        ]).

-include("riak_search.hrl").
-include_lib("lucene_parser/include/lucene_parser.hrl").

preplan(Op, State) -> 
    NewState = update_state(Op, State),
    Props = riak_search_op:preplan(Op#scope.ops, NewState),
    TargetNode = riak_search_op:get_target_node(Props),
    ScopeProp = {?OPKEY(target_node, Op), TargetNode},
    [ScopeProp|Props].


chain_op(Op, OutputPid, OutputRef, State) ->
    %% Update state and switch control to the group operator...
    NewState = update_state(Op, State),
    NewOp = #group { id=Op#scope.id, ops = Op#scope.ops },
    riak_search_op_group:chain_op(NewOp, OutputPid, OutputRef, NewState).

update_state(Op, State) ->
    %% Get the new index...
    OldIndex = State#search_state.index,
    NewIndex = riak_search_utils:coalesce(Op#scope.index, OldIndex),

    %% Get the new field...
    OldField = State#search_state.field,
    NewField = riak_search_utils:coalesce(Op#scope.field, OldField),

    %% Create the new SearchState...
    State#search_state {
      index=riak_search_utils:to_binary(NewIndex),
      field=riak_search_utils:to_binary(NewField)
     }.