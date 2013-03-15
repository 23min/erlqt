%%%'   HEADER
%%% @author Peter Bruinsma <peter@23min.com> 
%%% @since 
%%% @copyright 2013 Peter Bruinsma
%%% @doc 
%%% @end

-module(logga_sup).
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
%% {ChildId, StartFunc, Restart, Shutdown, Type, Modules}.
%% 		ChildId = unique identifier, eg module name
%% 		StartFunc = {M, F, A}
%%		Restart = permanent | temporary | transient
%%		Shutdown = time (milliseconds) before a child is shutdown via exit(Pid, kill)
%%				   after exit(ChildPid, shutdown)
%%		Type = worker | supervisor
%%		Modules = list containing the name of the child behavior callback module
%%
%% Usage: 
%% Child = ?CHILD(id, worker | supervisor)
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
	%% {ok, { {RestartStrategy, MaxRestart, MaxTime},[ChildSpecs]} }
    %% RestartStrategy = one_for_one | rest_for_one | one_for_all | simple_one_for_one.
    %% MaxRestart = max number of times to retry within MaxTime (seconds)
    %% MaxTime = max time (seconds) to try restarting a child
    Server = ?CHILD(logga_server, worker),
    Mq = ?CHILD(logga_mq_server, worker),
    Sub = ?CHILD(logga_sub_server, worker),
    {ok, { {one_for_one, 5, 10}, [Server, Mq, Sub]} }.