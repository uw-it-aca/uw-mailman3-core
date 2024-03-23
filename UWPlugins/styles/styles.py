from public import public
from mailman.interfaces.styles import IStyle
from mailman.styles.default import LegacyDefaultStyle
from mailman.interfaces.mailinglist import (
    DMARCMitigateAction, ReplyToMunging)
from zope.interface import implementer

# Documentation on List styles
# https://docs.mailman3.org/projects/mailman/en/latest/src/mailman/styles/docs/styles.html

@public
@implementer(IStyle)
class UWPrivateStyle(LegacyDefaultStyle):

    # Provide a unique name to this style so it doesn't clash with the ones
    # defined by default.
    name = 'UW-March-2024-Default'

    # Provide a usable description that will be shown to the users in Web
    # Interface.
    description = 'UW discussion mailing list style (March2024).'

    def apply(self, mailing_list):
        """See `IStyle`."""
        # Set settings from super class.
        super().apply(mailing_list)

        # Make modifications on top.
        self.display_name = 'UW created with our Style'
        # Mung From
        self.dmarc_mitigate_action = DMARCMitigateAction.munge_from
        # do it for everyone
        self.dmarc_mitigate_unconditionally = True

        # archives private and off
        self.archive_policy = 'private'

        # up the max message size
        self.max_message_size = 10240

        # don't adversite
        self.advertised = False
