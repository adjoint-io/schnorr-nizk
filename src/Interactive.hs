-- | Interactive variant of the Schnorr protocol
--
-- >>> (pubKey, privKey) <- generateKeys -- prover
-- >>> (pubCommit, privCommit) <- generateCommitment -- prover
-- >>> challenge <- generateChallenge "hello world" -- verifier
-- >>> let r = computeResponse privCommit privKey challenge -- prover
-- >>> verify pubKey pubCommit challenge r -- verifier
-- True
module Interactive (
  generateChallenge,
) where
import qualified Data.ByteString as BS
import           Crypto.Number.Generate     (generateBetween)
import           Crypto.Random.Types (MonadRandom)
import           Protolude

import           Schnorr

-- | Generate challenge from a given message
generateChallenge :: MonadRandom m => ByteString -> m Challenge
generateChallenge msg = generateBetween 0  (2^BS.length msg - 1)
