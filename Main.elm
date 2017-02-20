
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Comments.Models
import Comments.Views
import Comments.Updates

-- MODELS
type alias Model = { comments : Comments.Models.Model }
init = ({ comments = { list = [], details = Nothing, error = Nothing }}, Cmd.none)

-- UPDATES
type Msg
    = CommentsMsg Comments.Updates.Msg
update : Msg -> Model -> (Model, Cmd Msg)
update msg model
    = case msg of
        CommentsMsg msg -> let (commentsModel, cmd) = Comments.Updates.update msg model.comments
            in { model | comments = commentsModel } ! [Cmd.map CommentsMsg cmd]

-- VIEWS
view : Model -> Html Msg
view model
    = div []
        [ stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
        , stylesheet "style.css"
        , stylesheet "https://fonts.googleapis.com/css?family=Open+Sans|Roboto"
        , div [ class "container-fluid banner" ] [ h1 [] [ text "Elm Bootstrap Navigation" ] ]
        , Html.map CommentsMsg (Comments.Views.view model.comments)
        , div [ class "footer color-invert" ]
            [ div []
                [ a [ href "https://www.github.com/jakubrauch/elm-bootstrap-resource" ]
                    [ span [] [ text "https://github.com/jakubrauch/elm-bootstrap-resource" ]  ]
                ]
            ]
        ]


stylesheet : String -> Html Msg
stylesheet link = node "link" [ (href link), (rel "stylesheet"), (type_ "text/css") ] []

-- PROGRAM
main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
