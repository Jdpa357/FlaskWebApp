# Receive the message from user input
message = input("Type the message sent by Cesar >").upper()

# Receive the displacement number from user input
displacement = int(input("Type displacement number >"))

# Alphabet to use for the cypher algorithm
abc = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"

# New empty var to fill with the cyphered message
cypher = ""

for letter in message:
    if letter in abc:
        letter_pos = abc.index(letter)

        letter_newpos = (letter_pos + displacement) % len(abc)
        cypher += abc[letter_newpos]
    else:
        cypher += l

print("Cypher message: ", cypher)