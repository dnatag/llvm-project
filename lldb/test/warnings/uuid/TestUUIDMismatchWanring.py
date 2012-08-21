"""Test that the 'warning: UUID mismatch detected ...' message is emitted if a
dsym in vicinity of the executable does not match its UUID."""

import os, time
import unittest2
import lldb
import pexpect
from lldbtest import *

@unittest2.skipUnless(sys.platform.startswith("darwin"), "requires Darwin")
class UUIDMismatchWarningCase(TestBase):

    mydir = os.path.join("warnings", "uuid")

    @classmethod
    def classCleanup(cls):
        """Cleanup the test byproducts."""
        cls.RemoveTempFile("child_send.txt")
        cls.RemoveTempFile("child_read.txt")

    def setUp(self):
        TestBase.setUp(self)
        self.template = 'main.cpp.template'
        self.source = 'main.cpp'
        self.teardown_hook_added = False

    def test_uuid_mismatch_warning(self):
        """Test that the 'warning: UUID mismatch detected ...' message is emitted."""

        # Call the program generator to produce main.cpp, version 1.
        self.generate_main_cpp(version=1)
        self.line_to_break = line_number(self.source, '// Set breakpoint here.')
        self.buildDsym(clean=True)

        # Insert some delay and then call the program generator to produce main.cpp, version 2.
        time.sleep(5)
        self.generate_main_cpp(version=101)
        # Now call make again, but this time don't generate the dSYM.
        self.buildDwarf(clean=False)

        self.exe_name = 'a.out'
        self.check_executable_and_dsym(self.exe_name)

    def generate_main_cpp(self, version=0):
        """Generate main.cpp from main.cpp.template."""
        temp = os.path.join(os.getcwd(), self.template)
        with open(temp, 'r') as f:
            content = f.read()

        new_content = content.replace('%ADD_EXTRA_CODE%',
                                      'printf("This is version %d\\n");' % version)
        src = os.path.join(os.getcwd(), self.source)
        with open(src, 'w') as f:
            f.write(new_content)

        # The main.cpp has been generated, add a teardown hook to remove it.
        if not self.teardown_hook_added:
            self.addTearDownHook(lambda: os.remove(src))
            self.teardown_hook_added = True

    def check_executable_and_dsym(self, exe_name):
        """Sanity check executable compiled from the auto-generated program."""

        # The default lldb prompt.
        prompt = "(lldb) "

        # So that the child gets torn down after the test.
        self.child = pexpect.spawn('%s %s' % (self.lldbHere, self.lldbOption))
        child = self.child
        # Turn on logging for input/output to/from the child.
        with open('child_send.txt', 'w') as f_send:
            with open('child_read.txt', 'w') as f_read:
                child.logfile_send = f_send
                child.logfile_read = f_read

                child.expect_exact(prompt)
                child.setecho(True)

                # Execute the file command, followed by a breakpoint set, the
                # UUID mismatch warning should be generated by then.

                child.sendline("file %s" % exe_name)
                child.expect_exact(prompt)
                child.sendline("breakpoint set -f %s -l %d" % (self.source, self.line_to_break))
                child.expect_exact(prompt)
                child.sendline("run")
                child.expect_exact(prompt)

        # Now that the necessary logging is done, restore logfile to None to
        # stop further logging.
        child.logfile_send = None
        child.logfile_read = None
        
        with open('child_send.txt', 'r') as fs:
            if self.TraceOn():
                print "\n\nContents of child_send.txt:"
                print fs.read()
        with open('child_read.txt', 'r') as fr:
            from_child = fr.read()
            if self.TraceOn():
                print "\n\nContents of child_read.txt:"
                print from_child

            # Test that lldb emits the "UUID mismatch detected" message.
            self.expect(from_child, msg="UUID mismatch expected!", exe=False,
                substrs = ['warning: UUID mismatch detected'])


if __name__ == '__main__':
    import atexit
    lldb.SBDebugger.Initialize()
    atexit.register(lambda: lldb.SBDebugger.Terminate())
    unittest2.main()
