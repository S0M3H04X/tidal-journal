module TidalProc where

  import Sound.Tidal.Stream
  import Sound.Tidal.Pattern
  import Sound.Tidal.Parse
  import Sound.Tidal.OscStream

  port = 5000

  procShape = Shape {
    params = [
      F "hit" (Just 0),
      S "view" (Just ""),
      F "fade" (Just 0),
      F "a" (Just 0),
      F "b" (Just 0),
      F "c" (Just 0),
      F "d" (Just 0)
    ],
    cpsStamp = True,
    latency = 0.1
  }

  procSlang = OscSlang {
    path = "/proc_osc",
    timestamp = NoStamp,
    namedParams = False,
    preamble = []
  }

  procStream = do
    s <- makeConnection "127.0.0.1" port procSlang
    stream (Backend s $ (\_ _ _ -> return ())) procShape

  hit = makeF procShape "hit"
  view = makeS procShape "view"
  fade = makeF procShape "fade"
  a = makeF procShape "a"
  b = makeF procShape "b"
  c = makeF procShape "c"
  d = makeF procShape "d"
