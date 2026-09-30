---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 30
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Extract cepstral coefficients (MFCC/GTCC) from audio frames — use as compact spectral features for speech recognition and audio classification. | Cepstral Coefficients | Audio Toolbox |
| Split a signal into octave or fractional-octave bands — use for acoustic measurement, noise analysis, and sound-level metering. | Octave Filter Bank | Audio Toolbox |
| Measure momentary, short-term, and integrated loudness (LUFS) plus true-peak per ITU-R BS.1770 — use for broadcast/streaming loudness compliance. | Loudness Meter | Audio Toolbox |
| Play an audio signal to the sound-card output in real time — use to monitor or output audio during simulation. | Audio Device Writer | Audio Toolbox |
| Write audio (and optionally video) samples to a media file — use to record processed audio to disk. | To Multimedia File | Audio Toolbox |
| Generate a tunable periodic waveform (sine/square/sawtooth) with adjustable frequency and amplitude — use as a real-time tone or test-signal source. | Audio Oscillator | Audio Toolbox |
| Read audio (and optionally video) from a media file as a source — use to feed recorded audio into a processing chain. | From Multimedia File | Audio Toolbox |
| CREPE deep pitch estimation neural network. | CREPE | Audio Toolbox |
| Preprocess audio for CREPE deep pitch estimation. | CREPE Preprocess | Audio Toolbox |
| Estimate pitch with CREPE deep learning neural network. | Deep Pitch Estimator | Audio Toolbox |
| OpenL3 embeddings extraction network. | OpenL3 | Audio Toolbox |
| Extract OpenL3 embeddings. | OpenL3 Embeddings | Audio Toolbox |
| Perform dynamic range compression independently across each input channel. | Compressor | Audio Toolbox |
| Perform dynamic range expansion independently across each input channel. | Expander | Audio Toolbox |
| Perform limiting independently across each input channel. | Limiter | Audio Toolbox |
| Add artificial reverberation to mono or stereo audio signal. The output is always a stereo signal. | Reverberator | Audio Toolbox |
| Extract mel, Bark, or ERB spectrogram from audio. | Auditory Spectrogram | Audio Toolbox |
| Extract mel-frequency cepstral coefficients from audio. | MFCC | Audio Toolbox |
| Extract mel spectrogram from audio. | Mel Spectrogram | Audio Toolbox |
| Compute delta and delta-delta coefficients (time derivatives of audio features) — use to add temporal dynamics to feature vectors for speech/audio ML. | Audio Delta | Audio Toolbox |
| Design frequency-domain auditory filter bank. | Design Auditory Filter Bank | Audio Toolbox |
| Design frequency-domain mel filter bank. | Design Mel Filter Bank | Audio Toolbox |
| Multiband audio crossover filter | Crossover Filter | Audio Toolbox |
| Graphic equalizer | Graphic EQ | Audio Toolbox |
| Design a multiband parametric equalizer. Lowshelf and highshelf filters can be added as well as highpass (low cut) and lowpass (high cut) filters. | Multiband Parametric EQ | Audio Toolbox |
| Detect the presence of speech in an audio signal. | Voice Activity Detector | Audio Toolbox |
| Display the frequency spectrum of an audio signal during simulation — use to inspect spectral content. | Spectrum Analyzer | Audio Toolbox |
| Perform noise gating independently across each input channel. | Noise Gate | Audio Toolbox |
| Record audio stream from your computer's audio device. | Audio Device Reader | Audio Toolbox |
| Output values from controls on a MIDI control surface. Use a vector of control numbers to output values for multiple controls. Use the MATLAB midiid command to discover MIDI device names or MIDI device control numbers. | MIDI Controls | Audio Toolbox |
