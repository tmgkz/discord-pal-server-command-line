#!/usr/bin/python
import os
import json

import discord
from discord.ext import commands
from subprocess import call

# Directory
current_script_directory = os.path.dirname(os.path.abspath(__file__))
json_file_path = os.path.join(current_script_directory, "settings.json")

# get setting
with open(json_file_path, "r") as f:
    json_dict = json.load(f)
TOKEN = json_dict["token"]

intents = discord.Intents.default()
intents.message_content = True
client = commands.Bot(intents=intents, command_prefix="$", case_insensitive=True)


@client.event
async def on_ready():
    print("Bot is ready!")


@client.command()
async def restart(ctx: commands.Context):
    """serverリスタート"""
    call(["sudo", "systemctl", "restart", "palworld-dedicated.service"])
    await ctx.send("Server restart.")


client.run(TOKEN)
