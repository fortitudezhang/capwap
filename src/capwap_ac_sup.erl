-module(capwap_ac_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, new_wtp/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

new_wtp(Peer) ->
    lager:debug("Stating new WTP: ~p", [Peer]),
    R = supervisor:start_child(?SERVER, [Peer]),
    lager:debug("Result: ~p", [R]),
    R.

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
    {ok, {{simple_one_for_one, 1000, 1000},
	  [{capwap_ac, {capwap_ac, start_link, []}, temporary, 1000, worker, [capwap_ac]}]}}.
