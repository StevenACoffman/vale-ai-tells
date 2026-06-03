<!-- vale ai-tells-experimental.HeadingTitleCase = NO -->
<!-- vale ai-tells-experimental.VocabularySwap = NO -->

# False Positive Test Cases

These sentences should NOT trigger the new sequence rules.

## OverusedVocabularyVerbs: noun uses that should NOT trigger

The company's leverage in the negotiation was substantial.

The financial leverage ratio was calculated quarterly.

We will use the showcase as a demo venue.

The climbing harness attaches at the shoulders.

The barn has a harness rack by the door.

The rope harness supports up to 200 kg.

The embark terminal at the port was closed for repairs.

## AIAdjectiveNounPairs: technical uses that should NOT trigger

(Intentionally sparse. Calibrate based on real-world false positive data.)

## StructureAnnouncements: legitimate uses that should NOT trigger

(No known false positives. Verify against real-world data.)

## AbsoluteAssertions: legitimate uses that should NOT trigger

(No known false positives. Verify against real-world data.)

## ListIntroductions: legitimate uses that should NOT trigger

(No known false positives. Patterns are tightly scoped to list-announcement phrases.)

## UnpackExplore: legitimate uses that should NOT trigger

(No known false positives. Patterns are tightly scoped to explainer announcements.)

## HedgingPhrases: real requirements that should NOT trigger

It is important to test this before deploying to production.

It is essential to configure the firewall before going live.

It is critical to back up the database before migrating.

It is necessary to restart the service after updating the config.

## StackedAnaphora: legitimate "No" uses that should NOT trigger

No one expected the results to be that clear.

No, I do not think that is correct.

There is no way to know for certain.

No additional configuration is required for basic usage.

## MicDrop: legitimate short sentences that should NOT trigger

This is a critical security vulnerability that must be patched immediately.

The result is not clean enough to merge.

It is important to test this before deploying to production.

All four endpoints are returning errors after the deploy.

And the reason we need to rewrite the parser is the performance regression.

Both endpoints return the same status code when the upstream service is down.

Each handler validates its input before passing it to the service layer.

Every request must include an authorization header.

Nothing in the response body indicates which shard served the request.

None of the tests cover the edge case where the token has expired.

The schema changes frequently during early development, so pin your client version.

If the configuration changes, the service automatically restarts and picks up the new values.

The API has remained stable since the v2 release despite internal refactoring.

The logging is clean and structured with proper context.

Pure functions return the same output for the same input.

Just run the migration script and restart the service.

Clean up the stale connections before deploying the new version.

Simple types are easier to serialize than complex nested structures.

Plain text logs are sufficient for local development.

Bare metal servers offer better performance for latency-sensitive workloads.

Raw SQL queries bypass the ORM's query builder for complex joins.

Same as above, but with the timeout increased to 30 seconds.

With PostgreSQL, the binary requires a running database server on the network.

With practice, developers learn to spot these patterns quickly.

## ColloquialAssessments: literal uses that should NOT trigger

The plane lands at 6 PM.

The plane landed safely after the storm.

The bird lands on the branch outside the window.

The asteroid landed in the desert.

The kicker lands the field goal from 50 yards.

The dancer lands the jump cleanly.

The probe lands on the moon's south pole.

## FigurativeLands: literal landings that should NOT trigger

The skydiver lands in the field.

Snow lands on the windshield in winter.

The ball lands in the cup.

The drone lands on the pad automatically.

Public lands in the west are federally protected.

## ColloquialAssessments ("move"): literal uses that should NOT trigger

The next move in the protocol is a handshake.

His best move was to fold.

The move from monolith to services took two years.

A bold move from the new CEO.

<!-- Known limitation: chess analysis like "Nf3 is the move" or "White is the move"
     will trigger. Suppress per-section in chess writing. -->
<!-- vale ai-tells.ColloquialAssessments = NO -->
White is the move in this chess position.
Nf3 is the move after the Ruy Lopez.
<!-- vale ai-tells.ColloquialAssessments = YES -->

## ColloquialAssessments ("matters"): bare uses that should NOT trigger

<!-- Known limitation: the comparative-aphorism mic-drop
     ("X verbs more/less/faster/... than Y") now fires (added in
     v1.13.0). The shape is genuinely an AI tell most of the time,
     but legitimate human-subject uses do exist. Suppress
     per-section if legit. -->
<!-- vale ai-tells.MicDrop = NO -->
Latency matters more than throughput here.
<!-- vale ai-tells.MicDrop = YES -->

Every line of code matters when the binary is this small.

It matters whether the lock is held during the write.

<!-- Known limitation: definite-NP "The X matters." now fires (v1.12.0
     extended MicDrop from pronoun subjects to noun-phrase subjects).
     Suppress per-section if legit. -->
<!-- vale ai-tells.MicDrop = NO -->
The order of operations matters.
<!-- vale ai-tells.MicDrop = YES -->

## AnthropomorphicJustification ("work"): literal uses that should NOT trigger

<!-- Known limitation: bare "does/doing the work" now fires (v1.12.0
     dropped the qualified-shape exclusion). Human-subject uses with
     trailing "of X" qualifiers still trigger. Suppress per-section
     if legit. -->
<!-- vale ai-tells.AnthropomorphicJustification = NO -->
The team does the work of reviewing every PR.
<!-- vale ai-tells.AnthropomorphicJustification = YES -->

Engineers do the hard work of maintaining the runtime.

The interns did real work on the migration tooling.

Engineers do a lot of work that nobody sees.

## VocabularySwap ("unlock"): literal uses that should NOT trigger

Unlock the door before the alarm trips.

The phone unlocks with a fingerprint.

The achievement unlocked at level 30.

## VerbTricolon: noun lists that should NOT trigger

The building plan, the meeting agenda, and the ceiling height were all wrong.

New techniques, better processes, and fast workflows enable better outcomes.

Paris attractions, London landmarks, and Tokyo highlights are all worth visiting.

The morning shift, the evening shift, and the weekend shift all need coverage.

They need servers, databases, and load balancers.

We use PostgreSQL, Redis, and Elasticsearch.

You want speed, reliability, and simplicity.

## ShipOveruse: suffixes and compounds that should NOT trigger

Our relationship and their partnership deepened over the years.

Good leadership outlasts any membership fee.

She earned a scholarship and an internship.

The flagship product and the spaceship are just props.

He attends worship at the township chapel.

The shipment arrived and every shipment is tracked.

## ResonateOveruse: noun forms that should NOT trigger

The cavity has a resonant frequency.

Acoustic resonance filled the hall.

## OverusedVocabulary (hype verbs): literal forms that should NOT trigger

The supercharged engine roared to life.

A turbocharged sedan passed us.

## ContrastiveNegation: non-tells that should NOT trigger

The feature is no longer supported.

She paused, no longer sure of the answer.

We left at dawn, no sooner than we had to.

## GrowthMetaphors: scoped words that should NOT trigger

We chose the most viable option available.

Set the random seed before training the model.

The store sells fresh organic produce.

Her earliest memories date from infancy.

## SemicolonUsage: legitimate semicolons that should NOT trigger

We visited Paris, France; Berlin, Germany; and Tokyo, Japan.

Compute the centroid; if it is on the far side, reverse the order.
