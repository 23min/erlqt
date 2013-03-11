%%%'   HEADER
%%% @author Peter Bruinsma <peter@23min.com> 
%%% @since 
%%% @copyright 2013 Peter Bruinsma
%%% @doc 
%%% @end

-module(logga_app).
-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  	logga_sup:start_link().

stop(_State) ->
  	ok.