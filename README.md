<p align="center">
  <a href="http://www.adjoint.io"><img src="https://www.adjoint.io/images/logo-small.png" width="250"/></a>
</p>

The purpose of the Schnorr protocol is to allow one to prove the knowledge of a discrete logarithm without revealing its value.

Schnorr Identification Scheme
=============================

The Schnorr protocol is an example of a Sigma protocol. A Sigma protocol is a three-step protocol in which communication between prover and verifier goes forwards once, then backwards, then forwards again. In general terms:

- `P  ->  V`:  commitment
- `V  ->  P`:  challenge
- `P  ->  V`:  response (proof)

The Schnorr identification scheme runs interactively between the prover and the verifier. The protocol is defined for a cyclic group of order `n` with generator `G`.

The prover aims to convince the verifier that he knows some value `a`. Let `a` be her private key. Therefore, `P = G * [a]`**[1]** will be her public key. In order to prove knowledge of it, the prover interacts with the verifier in three passes:

- The prover commits to a random private commitment value `v`, chosen in the range `[1, n-1]`. This is the first message `commitment = G * [v]`.

- The verifier replies with a `challenge` chosen at random from `[0, 2^t - 1]`.

- After receiving the `challenge`, the prover sends the third and last message (the response) `resp = (v - challenge * a) mod n`.

The verifier accepts, if:
- The prover's public key, `P`, is a valid public key. It means that it must be a valid point on the curve and `P * [h]` is not a point at infinity, where `h` is the cofactor of the curve.

- The prover's commitment value is equal to `G * [r] + P * [challenge]`

```haskell
testInteractive :: IO Bool
testInteractive = do
  -- Prover
  (pubKey, privKey) <- generateKeys
  (pubCommit, privCommit) <- generateCommitment

  -- Verifier
  let msg = "Hello World"
  challenge <- generateChallenge msg

  -- Prover
  let resp = computeResponse privCommit privKey challenge

  -- Verifier
  pure $ verify pubKey pubCommit challenge resp
```

Zero Knowledge Proofs
=====================

A proof of knowledge is an interactive proof in which the prover succeeds in convincing a verifier that the prover knows something.

All proof systems have two requirements:

- **Completeness**: An honest verifier will be convinced of this fact by an untrusted prover.

- **Soundness**: No prover, even if it doesn't follow the protocol, can convince the honest verifier that it is true, except with some small probability.

It is assumed that the verifier is always honest.

Zero knowledge proofs are a way by which one party can prove to another party that she knows a private value x without exposing any information apart from the fact that she knows the value x.

Schnorr NIZK proof
==================

The original Schnorr identification scheme is made non-interactive through a Fiat-Shamir transformation, assuming that there exists a secure cryptographic hash function (i.e., the so-called random oracle model).

An oracle is considered to be a black box that outputs unpredictable but deterministic random values in response to a certain input. That means that, given the same input, the oracle will give back the same random output. The input to the random oracle, in the Fiat-Shamir heuristic, is specifically the transcript of the interaction up to that point. The challenge is then redefined as `challenge = H(g || V || A)`, where `H` is a secure cryptographic hash function like SHA-256. The bit length of the hash output should be at least equal to that of the order `n` of the considered subgroup.

This non-interactive variant of the Schnorr protocol is called the Schnorr NIZK proof.

```haskell

testNonInteractive :: IO Bool
testNonInteractive = do
  -- Prover
  (pubKey, privKey) <- generateKeys
  (pubCommit, privCommit) <- generateCommitment

  -- Verifier
  let challenge = mkChallenge pubKey pubCommit

  -- Prover
  let resp = computeResponse privCommit privKey challenge

  -- Verifier
  pure $ verify pubKey pubCommit challenge resp

```

Curves
======

This Schnorr implementation offers support for both SECp256k1 and Curve25519 curves,
which are Koblitz and Montgomery curves, respectively. Further information about
these curves can be found in the Uplink docs:

[SECp256k1 curve](https://www.adjoint.io/docs/cryptography.html#id1 "SECp256k1 curve")
[Curve25519 curve](https://www.adjoint.io/docs/cryptography.html#id2 "Curve25519 curve")

**References**:

1.  Hao, F. "Schnorr Non-interactive Zero-Knowledge Proof." Newcastle University, UK, 2017


**Notation**:

1. `P * [b]`: multiplication of a point P with a scalar b over an elliptic curve defined over a finite field modulo a prime number

License
-------

```
Copyright 2018 Adjoint Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
