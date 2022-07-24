#!/usr/bin/env python3
from pathlib import Path

import nuki
from nacl.public import PrivateKey
import sys

cwd = Path.cwd()
cfg = cwd.joinpath('nuki.cfg')

nukiMacAddress = "54:D2:72:1A:62:62"
name="ChasdOpener" # name that the Nuki uses for its own log

# generate the private key which must be kept secret
keypair = PrivateKey.generate()
myPublicKeyHex = keypair.public_key.__bytes__().hex()
myPrivateKeyHex = keypair.__bytes__().hex()
myID = 50
# id-type = 00 (app), 01 (bridge) or 02 (fob)
# take 01 (bridge) if you want to make sure that the 'new state available'-flag is cleared on the Nuki if you read it out the state using this library
myIDType = '01'
nuki.Nuki(nukiMacAddress, cfg).authenticateUser(myPublicKeyHex, myPrivateKeyHex, myID, myIDType, name)

