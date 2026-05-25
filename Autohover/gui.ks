LOCAL g IS GUI(200).

// b1 is a normal button that auto-releases itself:
// Note that the callback hook, myButtonDetector, is
// a named function found elsewhere in this same program:
LOCAL up_button IS g:ADDBUTTON("up").
SET up_button:ONCLICK TO increase_alt@.

// b2 is also a normal button that auto-releases itself,
// but this time we'll use an anonymous callback hook for it:
LOCAL down_button IS g:ADDBUTTON("down").
SET down_button:ONCLICK TO decrease_alt@.

g:show(). // Start showing the window.

function increase_alt {
  set tgt_height to tgt_height + 1.
}
function decrease_alt {
  set tgt_height to tgt_height - 1.
}
