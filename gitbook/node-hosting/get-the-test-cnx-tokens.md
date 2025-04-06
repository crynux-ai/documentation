# Get the Test CNX Tokens

Some test CNX tokens are required to start the node. The test CNX tokens can be acquired for free in the Discord server of Crynux:

{% embed url="https://discord.gg/y8YKxb7uZk" %}

## Find the Right Place to Issue the Command

The slash command can be used in two places:

* A private chat window to the HappyAIGen bot
* In the pubic channel `happy-aigen-discussions`&#x20;

In most other public channels, the slash command is forbidden to maintain a better environment for discussion.

## Issue the Command to Get Test CNX Tokens

{% hint style="danger" %}
**DO NOT copy & paste the command, it only works when typed in using keyboard.**
{% endhint %}

First of all join the HappyAIGen users using the following command:

```
/user join
```

Then bind the wallet address using the following command:

```
/node wallet {blockchain} {wallet_address}
```

**Remember to replace** `{wallet_address}` **with your real wallet address, and replace** `{blockchain}` **with the blockchain your node is running on.** For example:

```sh
# Example for Dymension
/node wallet dymension 0x2D49A3fb6C5d60fAe31efd6E5Fb743b8b87590EA

# Example for Near
/node wallet near 0x2D49A3fb6C5d60fAe31efd6E5Fb743b8b87590EA
```

<figure><img src="../.gitbook/assets/f8d5a672e0b753ad9f6ce99ff85a0fb.png" alt=""><figcaption></figcaption></figure>

After a short while, the test CNX tokens should appear in your node wallet.
