# enable syntax completion
try:
    import readline
    # use rich print instead of default
    from rich import print
except ImportError:
    print("Module readline not available.")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
