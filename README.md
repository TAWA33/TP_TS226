# TS226 – Channel Coding Lab (ETE7-CNUM1)

Matlab lab for the **Channel Coding** course at ENSEIRB-MATMECA (Bordeaux INP).

## Overview

This project simulates a coded digital communication chain and studies its performance:
bit error rate (BER), code rate and throughput.

The work focuses on **convolutional codes**. The encoder and the Viterbi decoder are written from scratch.

## Communication chain

```
u ──► Encoder ──► BPSK ──► AWGN channel ──► BPSK demod ──► Viterbi decoder ──► û
```

## Main functions

| File | Role |
|------|------|
| `cc_encode.m` | Convolutional encoder (starts in state 0, closed trellis) |
| `viterbi_decode.m` | Viterbi decoder for a closed trellis |

The trellis structures come from Matlab's `poly2trellis` (Communications Toolbox).

## Content

### Encoding and decoding

Both the encoder and the decoder work from the code's trellis, so any code given in octal notation can be used.
The encoder starts in state 0 and adds tail bits to return to state 0 (closed trellis).
The Viterbi decoder uses the soft values (LLRs) from the demodulator, keeps the best path to each state,
then traces it back to recover the message.

### Performance study

The chain is used to compare several convolutional codes:

- codes with different memory sizes (more states, more power, more compute),
- recursive and non-recursive encoders,
- long and short messages,
- a convolutional code combined with a CRC-like outer code (expurgated code).

Each code is assessed with BER vs Eb/N0 curves, compared to the uncoded BPSK case,
along with its code rate, minimum distance, coding gain and decoding throughput.
