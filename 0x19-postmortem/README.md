# Postmortem (Incident Report)

![error](Error_red.jpeg) ALERT!


An isolated Ubuntu 14.04 container running an Apache web server experienced an outage around 06:00 AM West African Time (WAT) in Nigeria, after the launch of ALX's System Engineering & DevOps project 0x19. The server returned 500 Internal Server Error's for GET requests, instead of an HTML file showing a simple Holberton WordPress site.

## Troubleshooting Steps:
Bug fixer ThankGod UGOBO [ugoMusk](https://github.com/ugoMusk) faced the issue when he opened the project and was asked to solve it, around 21:20 PM WAT. He quickly started working on the problem.

1. Used `ps aux` to check running processes. Two `apache2` processes - `root` and `www-data` -
were running correctly.

2. Checked the `sites-available` folder in the `/etc/apache2/` directory. Found out that
the web server was serving content from `/var/www/html/`.

3. In one terminal, ran `strace` on the PID of the `root` Apache process. In another, curled
the server. Hoped for the best... but got nothing. `strace` did not give any helpful
information.

4. Did step 3 again, but on the PID of the `www-data` process. Lowered hopes this
time... got lucky! `strace` showed an `-1 ENOENT (No such file or directory)` error
when trying to access the file `/var/www/html/wp-includes/class-wp-locale.phpp`.

5. Searched through files in the `/var/www/html/` directory one-by-one, using emacs i-search feature to find the wrong `.phpp` file extension. Found it in the
`wp-settings.php` file. (Line 137, `require_once( ABSPATH . WPINC . '/class-wp-locale.php' );`).

6. Deleted the extra `p` from the line.

7. Tested another `curl` on the server. 200 All good!

8. Wrote a Puppet manifest to automate fixing of the error.

## Summary:

In short, a typo. They happen. In full, the WordPress app had a critical
error in `wp-settings.php` when loading the file `class-wp-locale.phpp`. The right
file name, in the `wp-content` directory of the app folder, was
`class-wp-locale.php`.

Fix was simple: remove the extra `p`.

## Prevention

This outage was not a web server error, but an application error. To avoid such outages
in the future, please remember these things.

* Test! Test test test. Test the application before deploying. This error could have been found
and fixed earlier if the application was tested.

* Status monitoring. Use some uptime-monitoring service like
[UptimeRobot](./https://uptimerobot.com/) to alert right away when the website goes down.

Note that I wrote a Puppet manifest
[0-strace_is_your_friend.pp](https://github.com/ugoMusk/alx-system_engineering-devops/0x17-web_stack_debugging_3/0-strace_is_your_friend.pp)
to automate fixing of any same errors if they happen again in the future. The manifest
changes any `phpp` extensions in the file `/var/www/html/wp-settings.php` to `php`.

But of course, it will never happen again, because we're programmers, and we fix errors! :wink: