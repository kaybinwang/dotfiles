#!/usr/bin/env python

class UnsupportedCommand(Exception):
    def __init__(self, name):
        super(self)

class Command():
    def __init__(self):
        pass

    def subcommand(self, name, *args):
        if name == 'help':
            self.__help(args)
            return
        elif name == 'list':
            self.__list(args)
            return
        raise UnsupportedCommand(name)

    def __help(self, *args):
        raise UnsupportedCommand('help')

    def __list(self, *args):
        raise UnsupportedCommand('help')

UPDATE_DOC = '''

'''
class Update(Command):
    def __init__(self):
        pass

    def __help(self, *args):
        print(UPDATE_DOC)

    def __list(self, *args):
        raise UnsupportedCommand('list')
