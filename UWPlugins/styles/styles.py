from public import public
from mailman.interfaces.styles import IStyle
from mailman.styles.default import LegacyDefaultStyle
from mailman.interfaces.mailinglist import DMARCMitigateAction
from mailman.interfaces.archiver import ArchivePolicy
from zope.interface import implementer

# Documentation on List styles
# https://docs.mailman3.org/projects/mailman/en/latest/src/mailman/styles/docs/styles.html

@public
@implementer(IStyle)
class UWStyleArch(LegacyDefaultStyle):

    # Provide a unique name to this style so it doesn't clash with the ones
    # defined by default.
    name = 'UW-March-2024-Arch'

    # Provide a usable description that will be shown to the users in Web
    # Interface.
    description = 'UW list with archives (March2024).'

    def apply(self, mlist):

        # Set settings from super class.
        super().apply(mlist)

        # Mung From
        mlist.dmarc_mitigate_action = DMARCMitigateAction.munge_from
        # do it for everyone
        mlist.dmarc_mitigate_unconditionally = True

        # archives private and off
        mlist.archive_policy = ArchivePolicy.private

        # up the max message size
        mlist.max_message_size = 10240

        # don't adversite
        mlist.advertised = False

@public
@implementer(IStyle)
class UWStyleNoArch(LegacyDefaultStyle):

    # Provide a unique name to this style so it doesn't clash with the ones
    # defined by default.
    name = 'UW-March-2024-NoArch'

    # Provide a usable description that will be shown to the users in Web
    # Interface.
    description = 'UW list with NO archives (March2024).'

    def apply(self, mlist):

        # Set settings from super class.
        super().apply(mlist)

        # Mung From
        mlist.dmarc_mitigate_action = DMARCMitigateAction.munge_from
        # do it for everyone
        mlist.dmarc_mitigate_unconditionally = True

        # archives private and off
        mlist.archive_policy = ArchivePolicy.never

        # up the max message size
        mlist.max_message_size = 10240

        # don't adversite
        mlist.advertised = False
