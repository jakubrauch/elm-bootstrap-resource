module Comments.Updates exposing (Msg (..), update)

import Http
import Task exposing (Task)
import Json.Decode exposing (Decoder, list, field, string, int, map3, map5)
import Comments.Models exposing (..)


-- UPDATES
type Msg
    = GetComments -- obtains all comments from https://jsonplaceholder.typicode.com/comments
    | GotComments (Result Http.Error (List Comment)) -- when obtained can either be Http.Error or List Comment (on success)
    | GetCommentDetails Id -- obtains single comment with all its details from https://jsonplaceholder.typicode.com/comments/{id}
    | GotCommentDetails (Result Http.Error (CommentDetails))
    | BackCommentDetails


update : Msg -> Model -> (Model, Cmd Msg)
update msg model
    = case msg of
        GetComments -> ({ model | error = Nothing }, Http.send GotComments getComments)
        GotComments (Ok comments) -> ({ model | list = comments, details = Nothing }, Cmd.none)
        GotComments (Err error) -> ({ model | error = Just error }, Cmd.none)
        GetCommentDetails id -> ({ model | error = Nothing }, Http.send GotCommentDetails (getCommentDetails id))
        GotCommentDetails (Ok commentDetails) -> ({ model | details = Just commentDetails }, Cmd.none)
        GotCommentDetails (Err error) -> ({ model | error = Just error }, Cmd.none)
        BackCommentDetails -> ({ model | details = Nothing }, Cmd.none)


getComments : Http.Request (List Comment) -- the HTTP GET request that returns resulting List of Comments
getComments = Http.get "https://jsonplaceholder.typicode.com/comments/" decodeComments


decodeComments : Decoder (List Comment) -- decodes server's JSON response to List of Comments
decodeComments = list (map3 newComment (field "id" int) (field "body" string) (field "email" string))


newComment : Id -> Text -> Author -> Comment
newComment id text author = { id = id, text = text, author = author }


getCommentDetails : Id -> Http.Request CommentDetails
getCommentDetails id = Http.get ("https://jsonplaceholder.typicode.com/comments/" ++ (toString id)) decodeCommentDetails


decodeCommentDetails : Decoder CommentDetails
decodeCommentDetails = map5 newCommentDetails
    (field "postId" int)
    (field "id" int)
    (field "name" string)
    (field "body" string)
    (field "email" string)


newCommentDetails : PostId -> Id -> Name -> Text -> Author -> CommentDetails
newCommentDetails postId id name text author =
    { postId = postId
    , id = id
    , name = name
    , text = text
    , author = author
    }