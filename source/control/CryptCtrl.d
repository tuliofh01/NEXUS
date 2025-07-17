module control.CryptCtrl.d;

import crypto.base58;

import std.file;
import std.conv;
import std.range;
import std.array;
import std.base64;
import std.algorithm;
import std.exception;

import std.string : representation;

import std.digest.sha;
import std.digest.hmac;

import utils.WebResources;

class CryptCtrl
{

  private string serverSideConst = EnvConstants.ServerSideKey;

  string deriveKey(string userInput, string serverSalt = this.serverSideConst, uint iterations = 100_000)
  {
    // Step 1: Hash input and salt
    auto inputHash = sha256Of(userInput);
    auto saltHash = sha256Of(serverSalt);

    // Step 2: Base58 encode both
    string inputB58 = Base58.encode(inputHash);
    string saltB58 = Base58.encode(saltHash);

    // Step 3: Combine
    string combined = inputB58 ~ saltB58;

    // Step 4: PBKDF2 (HMAC-SHA256)
    auto keyBytes = pbkdf2(combined.representation, saltHash, iterations, 32);

    // Step 5: Output as Base58 string
    return Base58.encode(keyBytes);
  }

  ubyte[] pbkdf2(ubyte[] password, ubyte[] salt, uint iterations, size_t dkLen)
  {
    auto hmac = HMAC!SHA256(password);
    immutable hashLen = 32;
    immutable blockCount = (dkLen + hashLen - 1) / hashLen;

    ubyte[] derived;
    foreach (i; 1 .. blockCount + 1)
    {
      ubyte[] intBlock = [
        cast(ubyte)((i >> 24) & 0xff),
        cast(ubyte)((i >> 16) & 0xff),
        cast(ubyte)((i >> 8) & 0xff),
        cast(ubyte)(i & 0xff)
      ];
      ubyte[] u = hmac.digest(salt ~ intBlock);
      ubyte[] t = u.dup;

      foreach (_; 2 .. iterations + 1)
      {
        u = hmac.digest(u);
        foreach (j; 0 .. t.length)
          t[j] ^= u[j];
      }
      derived ~= t;
    }
    return derived[0 .. dkLen];
  }

  bool constantTimeCompare(string a, string b)
  {
    if (a.length != b.length)
      return false;
    ubyte result = 0;
    foreach (i; 0 .. a.length)
      result |= cast(ubyte)(a[i] ^ b[i]);
    return result == 0;
  }

  string encodeImage(string imgFileName)
  {
    string imgLocation = EnvConstants.ImgsPath ~ imgFileName;
    if (!isFile(imgLocation))
    {
      throw new Exception("Unable to find target file, make sure to store it inside assets/imgs.");
    }
    ubyte[] imgRaw = cast(ubyte[]) read(imgLocation);
    string base64Output = "";
    foreach (c; Base64.encoder(imgRaw))
    {
      base64Output ~ c;
    }
    return base64Output;
  }

}
