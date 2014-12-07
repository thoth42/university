## Registration number verification

Design a web interface for a list of teaching courses online.

### Task

- Design and develop a registration number verification mechanism
- That relies on public key cryptography

### Overview

Registration numbers - nobody likes them, especially when they are split into several chunks that have to go to
different edit widgets (so you must perform more than one copy/paste operation from the keygen. Nevertheless,
they are the most common method of verifying the authenticity of the installed application, and most commercial
software applies such checks.

### Description

Generator steps:
- First we generate a random string with a secret string.
- Then we encrypt that key using the way of public key cryptography.
- Then encode the key in base64.
- Save the encoded key in a file, later to be read.

Verifier steps:
- Reverse the base64 encoding.
- Decrypt the key using public key.
- Check the number and return a boolean value.

### Conclusion

After making this laboratory work I learn more about public key cryptography and how it can be used in the case
of hiding information about registration numbers or serial number. Also implemented a checker for verification of
validity of the serial number, the method used here is far from reality of generating and verificiation of serial numbers
but it serve the purpose to show the mechanism of publick key cryptography.
