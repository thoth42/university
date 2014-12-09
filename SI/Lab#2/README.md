## Rot13

Understand the rot13 cipher and build a tool that break it.

## Definition

ROT13 (”rotate by 13 places”, sometimes hyphenated ROT-13) is a simple letter substitution cipher that replaces
a letter with the letter 13 letters after it in the alphabet. ROT13 is an example of the Caesar cipher, developed in
ancient Rome.

In the basic Latin alphabet, ROT13 is its own inverse; that is, to undo ROT13, the same algorithm is applied, so
the same action can be used for encoding and decoding. The algorithm provides virtually no cryptographic security,
and is often cited as a canonical example of weak encryption.

## Description

The following program implements two way of breaking the rot13 substitution cipher:
- Frequency analysis
- Each substitution number

## Conclusion

After making this laboratory work I learn about different methods to break the ROT13 (and caesar ciphers) substition
cypher and it is easy to observe that algorithm provide almost no cryptographic security. Some of the possible
aproaches to improve the security are:

- *The Vignere cipher* - to use different shifts at different positions in the message. (additional key)
- *One-time pads* - where the previous additional key used is infinitely long or a completely random key.
- *Multi-character alphabets* - treate larger chunks of text as the characters of our message.
