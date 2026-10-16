# Assembly Tokenizer & Symbol Table Generator

A lexer and symbol table generator for MIPS-style assembly, written entirely in **MIPS assembly**. It reads a line of assembly code, splits it into typed tokens with a finite state machine, then finds label definitions and symbol references and records their addresses, like the first pass of a real assembler.

Built in three stages as a UMass Lowell course project (Spring 2026).

## What it does

Given input like:

```
FIRST: li $t0, VALUE #
bne $t0, $t1, FIRST #
```

it prints each token with its type, then the running symbol table:

```
      Symbol          Address             Declaration
  --------------  ------------------  -------------------
      FIRST           0x00000400          1
      VALUE           0x00000400          0
      FIRST           0x00000404          0
```

`1` means the symbol is **defined** on that line (a label), `0` means it's **referenced**. Each line advances the location counter by 4 bytes, starting at `0x400`.

## How to run it

**MARS (recommended)**
1. Install Java, then download MARS 4.5 (`Mars4_5.jar`).
2. Open `src/symbol_table.asm`, press **F3** to assemble and **F5** to run.
3. Type a line of assembly ending in `#` in the Run I/O panel, for example `FIRST: li $t0, VALUE #`.

Command line: `java -jar Mars4_5.jar src/symbol_table.asm`

**SPIM**
SPIM starts at a label named `main`, so add a `main:` line above `MAIN:`, then run `spim -file src/symbol_table.asm`.

Try `examples/sample_input.txt`, and compare with `examples/expected_output.txt`.

## How it works

**1. Character classification** (`PROCESS_INPUT`, `GET_CHAR_CODE`)
Each character is looked up in `CHAR_TABLE` and given a type: 1 digit, 2 letter, 3 operator, 4 punctuation, 5 end of line, 6 whitespace.

**2. Tokenizing with a finite state machine** (`PROCESS_TOKENS`)
`PARSE_STATE_TABLE` defines 12 states. Each state holds a pointer to an action function followed by the next state for every character type. The driver calls the current state's action with `jalr`, then uses the character type (times 4) as an offset to find the next state.

| Action | Job |
|---|---|
| `FSA_ACT_1` | Read the next character and its type into the parse variables |
| `FSA_ACT_2` | Start a new token with the current character |
| `FSA_ACT_3` | Append the current character to the token |
| `FSA_ACT_4` | Finish the token and set its type (number, identifier, or the character's own type) |

Parse state lives in a 28-byte struct on the stack. Tokens go into `TAB_TOKEN`: 20 entries of 12 bytes (8 bytes of text, 4-byte type).

**3. Building the symbol table** (`PROCESS_SYMBOLS`, `ADD_SYMBOL_TO_TABLE`)
If the second token is `:`, the first token is a label definition. Otherwise, identifiers that start an operand (right after the instruction or a comma) are references, while register names after `$` are skipped. Each symbol is stored in `TAB_SYMBOL` (16 bytes: 8 name, 4 address, 4 status) and printed with its address in hex by `PRINT_HEX`.

## Repository layout

```
src/symbol_table.asm      full program (stages 1 to 3)
stages/1_char_types.asm   stage 1: character classification
stages/2_tokenizer.asm    stage 2: finite state machine tokenizer
examples/                 sample input and expected output
```

## Fixes made after submission

- Saved `$t0` and `$t1` across calls to `ADD_SYMBOL_TO_TABLE`. They were being overwritten, so a single reference was added to the symbol table several times.
- Lines without a trailing `#` now end at the newline instead of running past the input.
- The program exits cleanly when input runs out instead of crashing.

---

Ahmed Salah · [azalah.github.io](https://azalah.github.io) · [LinkedIn](https://www.linkedin.com/in/ahmed-salah-cs2006)
