%%
%% logga.erl
%% logga entry point
%%

-module(logga).

-include("document.hrl").

-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start() -> ok
%% @doc Start the some_app server.
start() ->
	%ensure_started(crypto),
	%ensure_started(ranch),
	%ensure_started(cowboy),

    % setup database
    ensure_schema(),
    ensure_started(mnesia),

    ensure_started(logga).

%% @spec stop() -> ok
%% @doc Stop the some_app server.
stop() ->
    application:stop(logga).

ensure_schema() ->
    Node = node(),
    case mnesia:create_schema([Node]) of
        ok -> 
            io:format("Schema: create for Node ~w~n", [Node]),
            install([Node]),
            ok;
        {error, {Node, {already_exists, Node}}} -> 
            io:format("Schema: node already exists ~n", []),
            ok;
        Error -> 
            Error
    end.

install(Nodes) ->
    %ok = mnesia:create_schema(Nodes),
    
    % For the tables to be created on all nodes, Mnesia needs to run on all nodes.
    % For the schema to be created, Mnesia needs to run on no nodes. 
    % % Use rpc:multicall(Nodes, Module, Function, Args)
    %
    % Node A                     Node B
    % ------                     ------
    % create_schema -----------> create_schema
    % start Mnesia ------------> start Mnesia
    % creating table ----------> replicating table
    % creating table ----------> replicating table
    % stop Mnesia -------------> stop Mnesia
    rpc:multicall(Nodes, application, start, [mnesia]),
    R1 = mnesia:create_table(document,
                            [{attributes, record_info(fields, document)},
                            %{index, [#document.id]},
                            {disc_copies, Nodes}]),

    AllR = [X ++ "~n" || {X} <- [R1]],

    io:format("create_table: ~w~n", [AllR]),
    % mnesia:create_table(mafiapp_services,
    %                     [{attributes, record_info(fields, user)},
    %                     {index, [#mafiapp_services.to]},
    %                     {disc_copies, Nodes},
    %                     {type, bag}]),
    application:stop(mnesia).