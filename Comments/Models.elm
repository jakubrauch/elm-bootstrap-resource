
module Comments.Models exposing (..)

import Http

type alias Author = String
type alias Text = String
type alias PostId = Int
type alias Id = Int
type alias Name = String
type alias Comment = { id: Id, text: Text, author: Author }
type alias Detailed c = { c | postId: PostId, name: Name }
type alias CommentDetails = Detailed Comment

type alias Model = { list: List Comment, details: Maybe CommentDetails, error: Maybe Http.Error }