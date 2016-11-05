module Polygons exposing (polygon)

import Math.Vector2 as V2
import Math.Vector3 as V3
import Math.Matrix4 exposing (..)
import WebGL exposing (..)

type alias Vertex = { position : V3.Vec3, color : V3.Vec3 }

type alias Shape =
  { shape : Drawable Vertex
  , scale : V3.Vec3
  }

{--
    WebGL.toHtml
      [ Attr.width 400, Attr.height 400 ]
      [ WebGL.render vertexShader fragmentShader model.mesh { } ]
--}

nextNGonPoint : Float -> Float -> Int -> List V2.Vec2 -> List V2.Vec2
nextNGonPoint scale alpha current acc =
  let
    x = scale * cos (alpha * (toFloat current))
    y = scale * sin (alpha * (toFloat current))
    vertex = V2.vec2 x y
    next = current - 1
  in
    if current == 0 then
      vertex::acc
    else
      nextNGonPoint scale alpha next (vertex::acc)

polygon : V2.Vec2 -> Int -> Float -> V3.Vec3 -> Drawable Vertex
polygon position sides radius color =
  let
    alpha : Float
    alpha = pi * 2.0 / (toFloat sides)
    vertices = nextNGonPoint radius alpha (sides - 1) []
    vec2ToVertex = (\v -> 
      { position = V3.vec3 (V2.getX v) (V2.getY v) 0
      , color = color
      }
    )
  in
    List.map vec2ToVertex vertices
      |> TriangleFan

    
-- Shaders

vertexShader :
  Shader
  { attr | position: V3.Vec3, color: V3.Vec3 }
  { }
  { vcolor:V3.Vec3 }
vertexShader = [glsl|

attribute vec3 position;
attribute vec3 color;
varying vec3 vcolor;

void main () {
    gl_Position = vec4(position, 1.0);
    gl_PointSize = 4.0;
    vcolor = color;
}

|]


fragmentShader : Shader {} u { vcolor: V3.Vec3 }
fragmentShader = [glsl|

precision mediump float;
varying vec3 vcolor;

void main () {
    gl_FragColor = vec4(vcolor, 1.0);
}

|]
