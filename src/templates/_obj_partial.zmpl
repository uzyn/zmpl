@args user: *ZmplValue
<div>User email: {{user.email}}</div>
<div>User name: {{user.name}}</div>

@if ($.user.is_subscriber)
<div>User is a subscriber.</div>
@else
<div>Not a subscriber.</div>
@end
