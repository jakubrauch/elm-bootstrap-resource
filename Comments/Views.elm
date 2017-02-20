module Comments.Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http

import Comments.Models exposing (..)
import Comments.Updates exposing (..)

view : Model -> Html Msg
view model =
    div []
        [ div [ class "container contents" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-offset-2 col-sm-8 text-center" ]
                    [ (button [ class "btn btn-lg btn-primary", onClick Comments.Updates.GetComments ] [ text "Load comments" ]) ]
                ]
            , case model.error of
                Just err -> errorView err
                Nothing -> case model.details of
                    Just commentDetails -> commentDetailsView commentDetails
                    Nothing -> commentsView model.list
            ]
        ]

errorView : Http.Error -> Html Msg
errorView err
    = div [ class "row" ]
        [ div [ class "col-sm-offset-4 col-sm-4 text-center" ] [ text (toString err) ] ]

commentsView : List Comment -> Html Msg
commentsView comments
    = div [] <|
        (comments |> List.map (\comment ->
            div [ class "row" ]
                [ div [ class "col-sm-offset-2 col-sm-8" ]
                    [ div [ class "comment" ]
                        [ div [ class "row" ]
                            [ div [ class "col-sm-3 text-right padding-10" ] [ text comment.author ]
                            , div [ class "col-sm-7 border-left border-right padding-10" ] [ text comment.text ]
                            , div [ class "col-sm-2 text-right" ]
                                [ button
                                    [ class "btn btn-primary"
                                    , onClick (Comments.Updates.GetCommentDetails comment.id)
                                    ]
                                    [ text "more" ]
                                ]
                            ]
                        ]
                    ]
                ]
            )
        )

commentDetailsView : CommentDetails -> Html Msg
commentDetailsView commentDetails =
    div [ class "row" ]
        [ div [ class "col-sm-offset-3 col-sm-6" ]
            [ div [ class "comment" ]
                [ div [ class "row" ]
                    [ div [ class "col-sm-2 text-right" ] [ text "Id" ]
                    , div [ class "col-sm-10 text-left" ] [ text (toString commentDetails.id) ]
                    , div [ class "col-sm-2 text-right" ] [ text "PostId" ]
                    , div [ class "col-sm-10 text-left" ] [ text (toString commentDetails.postId) ]
                    , div [ class "col-sm-2 text-right" ] [ text "Name" ]
                    , div [ class "col-sm-10 text-left" ] [ text commentDetails.name ]
                    , div [ class "col-sm-2 text-right" ] [ text "Author" ]
                    , div [ class "col-sm-10 text-left" ] [ text commentDetails.author ]
                    , div [ class "col-sm-2 text-right" ] [ text "Text" ]
                    , div [ class "col-sm-10 text-left" ] [ text commentDetails.text ]
                    , div [ class "col-sm-12 text-center" ]
                        [ button [ class "btn btn-primary", onClick Comments.Updates.BackCommentDetails ] [ text "back" ] ]
                    ]
                ]
            ]
        ]


