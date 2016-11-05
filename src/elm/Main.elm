import Html exposing (Html, text, div, section, h1, p, a, header, h2, h3)
import Html.App as App
import Html.Attributes exposing (href, class)
import Graph


main = view model


type alias Model =
  { version : String
  , contributors : List String
  }


model : Model
model =
  { version = "1.0.0"
  , contributors = [ "Pietro Grandi", "Andrei Toma"]
  }

dressUp : Graph.Graph String () -- node labels are strings, edge labels are empty
dressUp =
  let
    nodes =
      [ Graph.Node 0 "Socks"
      , Graph.Node 1 "Undershirt"
      , Graph.Node 2 "Pants"
      , Graph.Node 3 "Shoes"
      , Graph.Node 4 "Watch"
      , Graph.Node 5 "Shirt"
      , Graph.Node 6 "Belt"
      , Graph.Node 7 "Tie"
      , Graph.Node 8 "Jacket"
      ]

    e from to =
      Graph.Edge from to ()

    edges =
      [ e 0 3 -- socks before shoes
      , e 1 2 -- undershorts before pants
      , e 1 3 -- undershorts before shoes
      , e 2 3 -- pants before shoes
      , e 2 6 -- pants before belt
      , e 5 6 -- shirt before belt
      , e 5 7 -- shirt before tie
      , e 6 8 -- belt before jacket
      , e 7 8 -- tie before jacket
      ]
  in
    Graph.fromNodesAndEdges nodes edges


iWantToWearShoes: List String
iWantToWearShoes =
  Graph.guidedDfs
    Graph.alongIncomingEdges            -- which edges to follow
    (Graph.onDiscovery (\ctx list ->    -- append node labels on discovery
      ctx.node.label :: list))
    [3 {- "Shoes" NodeId -}]            -- start with the node labelled "Shoes"
    []                                  -- accumulate starting with the empty list
    dressUp                             -- traverse our dressUp graph from above
    |> fst                              -- ignores the untraversed rest of the graph

view : Model -> Html a
view model =
  div [ class "container" ]
    [ header [ class "row" ]
      [ div [ class "col-xs-12 col-sm-12 col-md-12 menu" ]
        [ h1 [] [ text "Elm Quickstart" ] ]
      ]
    , section [ class "row" ]
      [ div [ class "col-xs-12 col-sm-10 col-md-8 col-lg-6" ]
        [ h2 [] [ text "Elm with Gulp and SASS configured" ]
        , h3 [] [ text ( "Version " ++ model.version ) ]
        , p []
          [ text "Have a look at the "
          , a [ href "https://github.com/pietro909/elm-quickstart/blob/master/README.md" ] [ text "readme" ]
          , text " for more information."
          , text (toString iWantToWearShoes)
          ]
        ]
      ]
    ]
