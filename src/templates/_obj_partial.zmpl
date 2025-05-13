@args user: *ZmplValue
<div>User email: {{user.email}}</div>
<div>User name: {{user.name}}</div>

@if (user.email == "john@example.com")
<div>Welcome, John!</div>
@else
<div>Not John.</div>
@end
