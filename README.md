# ELTableViewCell

Some UITableViewCell extensions.

Only current feature is that it allows you to listen to a "long press",
and hook up a callback method to when that action is triggered. The
example method animates the background.

Note: Using NSTimer for the animation since I need to be able to cancel
the animation when user cancels the touch. Animating using a block with
`UIViewAnimationOptionAutoreverse` and `UIViewAnimationOptionRepeat`
didn't seem to support that.
