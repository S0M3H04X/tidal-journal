const t = x => x.scaleTranspose("<0 2 4 3>/4").transpose(-2)
const s = x => x.scale(cat('C3 minor pentatonic','G3 minor pentatonic').slow(4))
const delay = new FeedbackDelay(1/8, .6).chain(vol(0.1), out());
const chorus = new Chorus(1,2.5,0.5).start();
stack(
  // melody
  "<<10 7> <8 3>>/4".struct("x*3").apply(s)
  .scaleTranspose("<0 3 2> <1 4 3>")
  .superimpose(scaleTranspose(2).early(1/8))
  .apply(t).tone(polysynth().set({
    ...osc('triangle4'),
    ...adsr(0,.08,0)
  }).chain(vol(0.2).connect(delay),chorus,out())).mask("<~@3 x>/16".early(1/8)),
  // pad
  "[1,3]/4".scale('G3 minor pentatonic').apply(t).tone(polysynth().set({
    ...osc('square2'),
    ...adsr(0.1,.4,0.8)
  }).chain(vol(0.2),chorus,out())).mask("<~ x>/32"),
  // xylophone
  "c3,g3,c4".struct("<x*2 x>").fast("<1 <2!3 [4 8]>>").apply(s).scaleTranspose("<0 <1 [2 [3 <4 5>]]>>").apply(t).tone(polysynth().set({
    ...osc('sawtooth4'),
    ...adsr(0,.1,0)
  }).chain(vol(0.4).connect(delay),out())).mask("<x@3 ~>/16".early(1/8)),
  // bass
  "c2 [c2 ~]*2".scale('C hirajoshi').apply(t).tone(synth({
    ...osc('sawtooth6'),
    ...adsr(0,.03,.4,.1)
  }).chain(vol(0.4),out())),
  // kick
  "<c1!3 [c1 ~]*2>*2".tone(membrane().chain(vol(0.8),out())),
  // snare
  "~ <c3!7 [c3 c3*2]>".tone(noise().chain(vol(0.8),out())),
  // hihat
  "c3*4".transpose("[-24 0]*2").tone(metal(adsr(0,.02)).chain(vol(0.5).connect(delay),out()))
).slow(1)
// strudel disable-highlighting