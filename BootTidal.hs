:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Context
import Sound.Tidal.Pattern
import Sound.Tidal.Chords

import System.IO (hSetEncoding, stdout, utf8)
hSetEncoding stdout utf8


-- Original osc messaging, target to supercollider
-- tidal <- startTidal (superdirtTarget {oLatency = 0.05, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cVerbose = True, cFrameTimespan = 1/20})


-- didacticpatternvisualizer setup by Iván Abreu
let  targetdpv = Target { oName = "didacticpatternvisualizer", oAddress = "127.0.0.1", oPort = 1818, oLatency = 0.2, oWindow = Nothing, oSchedule = Live, oBusPort = Nothing, oHandshake = False }
     formatsdpv = [OSC "/delivery"  Named {requiredArgs = []} ]
     oscmapdpv = [(targetdpv, formatsdpv), (superdirtTarget, [superdirtShape])]
     grid = pS "grid"
     connectionN = pI "connectionN"
     connectionMax = pI "connectionMax"
     speedSequenser = pF "speedSequenser"
     clear = pI "clear"
     sizeMin = pF "sizeMin"
     sizeMax = pF "sizeMax"
     figure = pS "figure"
     color = pS "color"

tidal <- startStream defaultConfig oscmapdpv
--

-- ofxTidal
-- let sdTarget    = superdirtTarget {oLatency = 0.1, oAddress = "127.0.0.1", oPort = 57120}
--     -- openFrameworks OSC target
--     ofxTarget   = Target {oName = "ofx", oAddress = "127.0.0.1", oPort = 2020, oLatency = 0.1, oSchedule = Live, oWindow = Nothing, oHandshake = False, oBusPort = Nothing}
--     -- openFrameworks OSC message structure
--     ofxShape    = OSC "/ofx" $ ArgList [("ofx", Nothing), ("vowel", Just $ VS "")]
--     -- Additional parameters
--     ofx         = pF "ofx"
--
-- tidal <- startStream (defaultConfig {cFrameTimespan = 1/20}) [(sdTarget, [superdirtShape]), (ofxTarget, [ofxShape])]


-- Tidal-vis
-- Target and shape for pattern visualizing.
-- patternTarget = Target { oName = "Pattern handler", oAddress = "127.0.0.1", oPort = 5050, oBusPort = Nothing, oLatency = 0.02, oWindow = Nothing, oSchedule = Pre BundleStamp, oHandshake = False }
-- patternShape = OSC "/trigger/something" $ Named {requiredArgs = []}

-- Target for playing music via SuperCollider.
-- musicTarget = superdirtTarget { oLatency = 0.1, oAddress = "127.0.0.1", oPort = 57120 }

-- config = defaultConfig {cFrameTimespan = 1/20}

-- Send pattern as OSC both to SuperCollider and to tidal-vis.
-- tidal <- startStream config [(musicTarget, [superdirtShape]), (patternTarget, [patternShape])]

-- Send pattern as OSC to SuperCollider only.
-- tidal <- startTidal musicTarget config



:{
let only = (hush >>)
    p = streamReplace tidal
    hush = streamHush tidal
    panic = do hush
               once $ sound "superpanic"
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    unmuteAll = streamUnmuteAll tidal
    unsoloAll = streamUnsoloAll tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setCycle = streamSetCycle tidal
    setcps = asap . cps
    getcps = streamGetcps tidal
    getnow = streamGetnow tidal
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    jumpMod' i t p = transition tidal True (Sound.Tidal.Transition.jumpMod' t p) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
    d1 = p 1 . (|< orbit 0)
    d2 = p 2 . (|< orbit 1)
    d3 = p 3 . (|< orbit 2)
    d4 = p 4 . (|< orbit 3)
    d5 = p 5 . (|< orbit 4)
    d6 = p 6 . (|< orbit 5)
    d7 = p 7 . (|< orbit 6)
    d8 = p 8 . (|< orbit 7)
    d9 = p 9 . (|< orbit 8)
    d10 = p 10 . (|< orbit 9)
    d11 = p 11 . (|< orbit 10)
    d12 = p 12 . (|< orbit 11)
    d13 = p 13
    d14 = p 14
    d15 = p 15
    d16 = p 16
:}

:{
let getState = streamGet tidal
    setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
:}


-- From Kindohm
let rip a b p = within (0.25, 0.75) (slow 2 . stutWith 8 (b/(-8)) (|* gain a)) p
    rip' a b c d e p = within (a, b) (slow 2 . stutWith c (e/(-8)) (|* gain d)) p
    spike p = ((# delaytime (range 0.001 0.3 $ slow 7.1 sine)) . (#delayfeedback (range 0.7 0.99 $ slow 6.71 sine))) $ p
    spike' a p = (# delay a) $ spike $ p
    ghost'' a f p = superimpose (((a/2 + a*2) ~>) . f) $ superimpose (((a + a/2) ~>) . f) $ p
    ghost' a b c d p = ghost'' a ((|* gain b) . (# end c) . (|* speed d)) p
    jit start amount p = within(start, (start + 0.5)) (trunc  (amount)) p -- what's "within" & "trunc"
    -- replace p with empty
    gtfo p = (const $ s "~") $ p
    gtfo' p = (const $ midinote "~") $ p
    gtfom = gtfo'
    gtfo2 = gtfo'
    echo   = stutter (2 :: Int)
    triple = stutter (3 :: Int)
    quad   = stutter (4 :: Int)
    double = echo
    -- shifting pattern
    shift p = (1 <~) p
    shift' x p = (x <~) p
    one p = stutWith 2 (0.125/2) id $ p -- what's "id"
    one' p = rarely (stutWith 2 (0.125/2) id) $ shift' 1024 $ p -- what's "id"
    one'' p = sometimes (stutWith 2 (0.125/2) id) $ shift' 1024 $ p -- what's "id"
    rep n p = stutWith (n) (0.125*3) id $ p
    rep' n p = stutWith (n) (0.125/2*3) id $ p
    rep'' n p = stutWith (n) (0.125/4*3) id $ p
    -- breakbeat
    brakk samps = ((# unit "c") . (# speed "8")) $ s (samples samps (irand 10))
    brakk4 samps = ((# unit "c") . (# speed "4")) $ s (samples samps (irand 10))
    move p = foldEvery [3,4] (0.25 <~) $ p
    crushit p = (# crush (range 3 8 $ slow 1.1 tri)) $ p
    thicken' x percent p = superimpose ((# pan 1) . (|* speed percent)) $ ((# speed x) . (# pan 0)) $ p

-- Geikha's drumMachine
let drumMachine name ps = stack (map (\ x -> (# s (name ++| (extractS "s" (x)))) $ x) ps)
    drumFrom name drum = s (name ++| drum)
    drumM = drumMachine
    drumF = drumFrom

-- Breakcore
let runmod r m o = ((run r) |% m |+ o)
    runmod' r m mul o = ((run r) |% m |* mul |+ o)
    slicemod r m o = slice r (runmod r m o)
    bitemod r m o = bite r (runmod r m o)




-- let td_s = pI "td_s"

:set prompt "50M3H04X> "
:set prompt-cont ""

default (Pattern String, Integer, Double)
