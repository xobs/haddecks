import subprocess

from migen.fhdl.module import Module
from litex.soc.integration.doc import AutoDoc, ModuleDoc
from litex.soc.interconnect.csr import CSRStorage, CSRStatus, CSRField, AutoCSR

class Version(Module, AutoCSR):
    def __init__(self, model, models, seed):
        """Create a `Version` block.

        Arguments:

        model (int): The value of the :obj:`CSRStatus(model)` field.
        models: a list() of (value, "shortname", "description") tuples.
        """
        self.intro = ModuleDoc("""SoC Version Information

            This block contains various information about the state of the source code
            repository when this SoC was built.
            """)

        def makeint(i, base=10):
            try:
                return int(i, base=base)
            except:
                return 0
        def get_gitver():
            def decode_version(v):
                version = v.split(".")
                major = 0
                minor = 0
                rev = 0
                if len(version) >= 3:
                    rev = makeint(version[2])
                if len(version) >= 2:
                    minor = makeint(version[1])
                if len(version) >= 1:
                    major = makeint(version[0])
                return (major, minor, rev)
            git_rev_cmd = subprocess.Popen(["git", "describe", "--tags", "--dirty=+"],
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE)
            (git_stdout, _) = git_rev_cmd.communicate()
            if git_rev_cmd.wait() != 0:
                print('unable to get git version')
                return
            raw_git_rev = git_stdout.decode().strip()

            dirty = 0
            if raw_git_rev[-1] == "+":
                raw_git_rev = raw_git_rev[:-1]
                dirty = 1

            parts = raw_git_rev.split("-")
            major = 0
            minor = 0
            rev = 0
            gitrev = 0
            gitextra = 0

            if len(parts) >= 3:
                if parts[0].startswith("v"):
                    version = parts[0]
                    if version.startswith("v"):
                        version = parts[0][1:]
                    (major, minor, rev) = decode_version(version)
                gitextra = makeint(parts[1])
                if parts[2].startswith("g"):
                    gitrev = makeint(parts[2][1:], base=16)
            elif len(parts) >= 2:
                if parts[1].startswith("g"):
                    gitrev = makeint(parts[1][1:], base=16)
                version = parts[0]
                if version.startswith("v"):
                    version = parts[0][1:]
                (major, minor, rev) = decode_version(version)
            elif len(parts) >= 1:
                version = parts[0]
                if version.startswith("v"):
                    version = parts[0][1:]
                (major, minor, rev) = decode_version(version)

            return (major, minor, rev, gitrev, gitextra, dirty)

        (major, minor, rev, gitrev, gitextra, dirty) = get_gitver()

        self.major = CSRStatus(8, reset=major, description="Major git tag version.  For example, this firmware was built from git tag ``v{}.{}.{}``, so this value is ``{}``.".format(major, minor, rev, major))
        self.minor = CSRStatus(8, reset=minor, description="Minor git tag version.  For example, this firmware was built from git tag ``v{}.{}.{}``, so this value is ``{}``.".format(major, minor, rev, minor))
        self.revision = CSRStatus(8, reset=rev, description="Revision git tag version.  For example, this firmware was built from git tag ``v{}.{}.{}``, so this value is ``{}``.".format(major, minor, rev, rev))
        self.gitrev = CSRStatus(32, reset=gitrev, description="First 32-bits of the git revision.  This documentation was built from git rev ``{:08x}``, so this value is {}, which should be enough to check out the exact git version used to build this firmware.".format(gitrev, gitrev))
        self.gitextra = CSRStatus(10, reset=gitextra, description="The number of additional commits beyond the git tag.  For example, if this value is ``1``, then the repository this was built from has one additional commit beyond the tag indicated in `MAJOR`, `MINOR`, and `REVISION`.")
        self.dirty = CSRStatus(fields=[
            CSRField("dirty", reset=dirty, description="Set to ``1`` if this device was built from a git repo with uncommitted modifications.")
        ])

        model_val = None
        for model_check in models:
            try:
                if int(model_check[0]) == int(model):
                    model_val = int(model_check[0])
            except:
                pass
            try:
                if model_check[1] == model:
                    model_val = int(model_check[0])
            except:
                pass
        if model_val is None:
            raise ValueError("Model not found in `models` list!")

        self.model = CSRStatus(fields=[
            CSRField("model",
                    reset=model_val,
                    size=8,
                    description="Contains information on which model device this was built for.",
                    values=models
            )
        ])
        self.seed = CSRStatus(32, reset=seed, description="32-bit seed used for the place-and-route.")

        self.comb += [
            self.major.status.eq(major),
            self.minor.status.eq(minor),
            self.revision.status.eq(rev),
            self.gitrev.status.eq(gitrev),
            self.gitextra.status.eq(gitextra),
            self.dirty.fields.dirty.eq(dirty),
            self.model.fields.model.eq(model_val),
            self.seed.status.eq(seed),
        ]
