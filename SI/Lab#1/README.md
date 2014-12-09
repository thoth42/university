## Hash algorithms

Understand the purpose of hashing algorithms and create a tool that solves a problem using one of them.

## Generic requirements

### Directory integrity checker

This program keeps an eye on the contents of a directory, notifying you when something inside it has changed. It is
ran at regular intervals by a scheduler, comparing the current state of the system with a previous snapshot, reporting
differences it found. Thus, if your system was hacked and malware was planted into the file system, or if the existing
files were modified to include malicious code - you’ll know right away.

### Dedupe

A duplicate finder, which analyzes a given directory and prints a list of identical files that have different names or
paths.

### Description

- Start the scheduler
- Create the class responsilbe for logic
- Initiate a dictionary with path and size of file
- Filter by given options
- Check the database if is empty introduce the data to it
- If database is not empty check each file wtih current state.
- And create a result based on hash comparision of them.

## Conclusion

After making this laboratory work I learn about different purposes of hashing algorithms. Hash functions are related
to (and often confused with) checksums, check digits, fingerprints, randomization functions, error-correcting codes,
and ciphers, usually applied to detect duplicated records in a large files (similar DNA sequence) and allows one to
easily verify that some input data matches a stored hash value. If we compare some of hash algorithms like MD5,
SHA1 or SHA512 they will not improve the security of the construction so much. Computing a SHA256 or SHA512
hash is very fast. An attacker with common hardware could still try tens of millions of hashes per second. Good
password hashing functions include a work factor to slow down attackers.
