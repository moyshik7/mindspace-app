import 'package:flutter/material.dart';
import 'models/course_model.dart';
import 'models/post_model.dart';
import 'models/comment_model.dart';
import 'models/guide_model.dart';
import 'models/tip_model.dart';

class DummyData {
  DummyData._();

  // ─── DAILY TIPS ──────────────────────────────────────────────
  static final List<TipModel> tips = [
    const TipModel(
      title: 'Breathe Deeply',
      shortText: 'Take 5 deep breaths before responding to a stressful message.',
      detail:
          'Deep breathing activates your parasympathetic nervous system, slowing your heart rate and lowering blood pressure. Try the 4-7-8 technique: inhale for 4 seconds, hold for 7, exhale for 8. This simple practice can transform how you respond to daily stressors.',
    ),
    const TipModel(
      title: 'Stay Hydrated',
      shortText: 'Drink a glass of water. Your brain is 75% water.',
      detail:
          'Even mild dehydration can affect mood, energy levels, and cognitive function. Keeping a water bottle nearby and sipping throughout the day can improve concentration and reduce feelings of anxiety. Aim for 8 glasses a day.',
    ),
    const TipModel(
      title: 'Practice Gratitude',
      shortText: 'Name one thing you\'re grateful for right now.',
      detail:
          'Gratitude rewires your brain for positivity. Studies show that people who regularly practice gratitude experience fewer toxic emotions like envy and resentment. Try keeping a gratitude journal — write 3 things you\'re thankful for each night before bed.',
    ),
    const TipModel(
      title: 'Move Your Body',
      shortText: 'A 10-minute walk can boost your mood for 2 hours.',
      detail:
          'Physical movement releases endorphins, serotonin, and dopamine — your brain\'s feel-good chemicals. You don\'t need an intense workout. Even gentle stretching, a short walk, or dancing to your favorite song counts.',
    ),
    const TipModel(
      title: 'Digital Detox',
      shortText: 'Put your phone down for 15 minutes and notice how you feel.',
      detail:
          'Constant notifications fragment our attention and increase cortisol levels. Schedule small "phone-free" windows during your day. Start with 15 minutes and gradually increase. Notice how your thoughts settle when you\'re not being pulled in by screens.',
    ),
    const TipModel(
      title: 'Connect',
      shortText: 'Send a kind message to someone you care about.',
      detail:
          'Social connection is a fundamental human need. Even a brief positive interaction can boost oxytocin levels and reduce stress. A thoughtful text, a genuine compliment, or simply asking "How are you really doing?" can strengthen bonds and lift your spirits.',
    ),
    const TipModel(
      title: 'Self-Compassion',
      shortText: 'Talk to yourself like you would to a good friend.',
      detail:
          'We\'re often our own harshest critics. Next time you catch negative self-talk, pause and ask: "Would I say this to someone I love?" Replace harsh judgments with understanding. Remember, you\'re doing the best you can with what you have.',
    ),
    const TipModel(
      title: 'Ground Yourself',
      shortText: 'Feel your feet on the floor. You are here, you are safe.',
      detail:
          'Grounding techniques bring you back to the present moment when anxiety pulls you elsewhere. Try the 5-4-3-2-1 method: notice 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste.',
    ),
    const TipModel(
      title: 'Rest Is Productive',
      shortText: 'You don\'t need to earn your rest. You deserve it.',
      detail:
          'In a world that glorifies hustle, rest can feel like laziness. But rest is essential for creativity, memory consolidation, and emotional regulation. Quality rest — whether it\'s a nap, reading, or simply sitting still — is one of the most productive things you can do.',
    ),
    const TipModel(
      title: 'Set a Boundary',
      shortText: 'It\'s okay to say no without giving a reason.',
      detail:
          'Boundaries protect your energy and mental health. Start small: decline an invitation you don\'t want to attend, or let a non-urgent message wait until tomorrow. Remember, "No" is a complete sentence. The people who matter will respect your limits.',
    ),
  ];

  static TipModel get todaysTip {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return tips[dayOfYear % tips.length];
  }

  // ─── QUICK GUIDES ──────────────────────────────────────────
  static final List<GuideModel> guides = [
    GuideModel(
      id: 'guide_1',
      title: '5-4-3-2-1 Grounding',
      emoji: '🌿',
      readTime: '2 min read',
      gradientColors: [const Color(0xFF2ecc71), const Color(0xFF27ae60)],
      content: '''
# 5-4-3-2-1 Grounding Technique

This powerful technique uses your five senses to bring you back to the present moment. It's especially helpful during anxiety or panic.

## How It Works

**5 — SEE:** Look around and name 5 things you can see. Look for small details: the pattern on a ceiling tile, the way light reflects off a surface.

**4 — TOUCH:** Notice 4 things you can physically feel. The texture of your clothing, the smooth surface of a table, the warmth of sunlight on your skin.

**3 — HEAR:** Listen for 3 sounds. External sounds like birds, traffic, or the hum of a refrigerator. Or internal sounds like your own breathing.

**2 — SMELL:** Identify 2 things you can smell. If you can't immediately smell anything, walk to somewhere you can like a kitchen or outdoors.

**1 — TASTE:** Notice 1 thing you can taste. It might be the lingering taste of coffee, toothpaste, or you can keep a mint or piece of gum handy.

## Tips for Best Results
• Practice this technique regularly, even when you're calm
• Take your time with each step
• Try to be specific and detailed in your observations
• Breathe slowly throughout the exercise
• Remember: there's no wrong way to do this
      ''',
    ),
    GuideModel(
      id: 'guide_2',
      title: 'Box Breathing',
      emoji: '💨',
      readTime: '2 min read',
      gradientColors: [const Color(0xFF3498db), const Color(0xFF2980b9)],
      content: '''
# Box Breathing Technique

Used by Navy SEALs and first responders, box breathing is a powerful stress management technique that calms your nervous system in minutes.

## The 4-4-4-4 Pattern

**Step 1 — Inhale (4 seconds)**
Breathe in slowly through your nose, filling your lungs completely. Count 1...2...3...4.

**Step 2 — Hold (4 seconds)**
Gently hold your breath. Don't clamp down — just pause. Count 1...2...3...4.

**Step 3 — Exhale (4 seconds)**
Release your breath slowly through your mouth. Count 1...2...3...4.

**Step 4 — Hold (4 seconds)**
Before your next breath, hold. Count 1...2...3...4.

## Repeat 4-6 Cycles

That's about 5 minutes of practice. You'll likely feel calmer after just 2-3 cycles.

## When to Use It
• Before a stressful meeting or conversation
• When you feel anxiety building
• Before bed to promote restful sleep
• During a panic or anxiety attack
• Any time you need to reset your nervous system
      ''',
    ),
    GuideModel(
      id: 'guide_3',
      title: 'Cognitive Reframing',
      emoji: '🧠',
      readTime: '3 min read',
      gradientColors: [const Color(0xFF9b59b6), const Color(0xFF8e44ad)],
      content: '''
# Cognitive Reframing

Cognitive reframing is a psychological technique for changing the way you look at something and, as a result, changing how you experience it.

## The ABCDE Model

**A — Activating Event:** What happened? Describe the situation objectively.

**B — Belief:** What did you tell yourself about it? What assumptions did you make?

**C — Consequence:** How did that belief make you feel? What did you do?

**D — Dispute:** Challenge your belief. Is it factual? Is there another way to see it?

**E — Effect:** How do you feel after reframing? What's a more balanced perspective?

## Common Thinking Traps
• **All-or-nothing:** "If it's not perfect, I've failed."
• **Catastrophizing:** "This is the worst thing that could happen."
• **Mind reading:** "They must think I'm stupid."
• **Should statements:** "I should be further along by now."
• **Overgeneralizing:** "This always happens to me."

## Reframing in Practice

**Trap:** "I made a mistake at work. I'm terrible at my job."

**Reframe:** "I made a mistake. Everyone makes mistakes. This is an opportunity to learn and grow. One mistake doesn't define my ability."

## Tips
• Write your reframes down — it makes them more powerful
• Practice daily, even with small frustrations
• Be patient — this skill takes time to develop
• Celebrate when you catch a thinking trap
      ''',
    ),
    GuideModel(
      id: 'guide_4',
      title: 'The 3-3-3 Rule',
      emoji: '✋',
      readTime: '1 min read',
      gradientColors: [const Color(0xFFe67e22), const Color(0xFFd35400)],
      content: '''
# The 3-3-3 Rule for Anxiety

When anxiety strikes and your mind starts racing, the 3-3-3 rule is a quick and easy way to center yourself.

## The Three Steps

**Step 1 — Name 3 Things You See**
Look around your environment. Name three things your eyes land on. A clock, a plant, a coffee mug. Actually say them out loud or in your mind.

**Step 2 — Name 3 Sounds You Hear**
Tune into your ears. What three sounds can you identify? Maybe the hum of air conditioning, distant traffic, or someone typing.

**Step 3 — Move 3 Parts of Your Body**
Wiggle your fingers, roll your shoulders, stomp your feet. Physical movement interrupts the anxiety loop in your brain.

## Why It Works

Anxiety often comes from being trapped in future-focused "what if" thoughts. The 3-3-3 rule forces your brain to engage with the present moment, breaking the cycle of anxious rumination.

## Make It a Habit
• Practice when calm so it becomes automatic during anxiety
• Teach it to friends and family
• It takes less than 30 seconds
• You can do it anywhere, anytime, without anyone noticing
      ''',
    ),
  ];

  // ─── COURSES ──────────────────────────────────────────
  static final List<CourseModel> courses = [
    CourseModel(
      id: 'course_1',
      title: 'Managing Anxiety Day by Day',
      description:
          'Learn practical, evidence-based strategies to understand and manage anxiety in your daily life. This course covers the science behind anxiety, grounding techniques, thought pattern recognition, and building a personalized toolkit for calmer days.',
      instructor: 'Dr. Sarah Chen',
      lessonCount: 10,
      difficulty: 'Beginner',
      duration: '~40 min total',
      emoji: '🌊',
      gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
      lessons: [
        const LessonModel(
          title: 'Understanding Anxiety',
          duration: '4 min',
          content: '''Understanding Anxiety

Anxiety is one of the most common mental health experiences worldwide. But what exactly is it?

At its core, anxiety is your body's natural alarm system. It's designed to protect you from danger. When your brain perceives a threat — real or imagined — it triggers a cascade of physical and mental responses.

The Fight-or-Flight Response

When danger is detected, your amygdala (the brain's alarm center) sends signals to release stress hormones like cortisol and adrenaline. This causes:
• Rapid heartbeat
• Shallow breathing
• Tense muscles
• Racing thoughts
• Hypervigilance

This response was incredibly useful for our ancestors facing physical threats. But in modern life, it can be triggered by emails, social situations, or even our own thoughts.

Normal vs. Problematic Anxiety

Everyone experiences anxiety. It's normal before a job interview, before a big presentation, or when facing uncertainty. This is adaptive anxiety — it motivates preparation and keeps you alert.

Anxiety becomes problematic when:
• It's disproportionate to the situation
• It persists even when the threat is gone
• It interferes with daily functioning
• It causes avoidance of normal activities

Key Takeaway: Anxiety isn't your enemy. It's a misfiring alarm system that can be recalibrated. This course will teach you how.''',
        ),
        const LessonModel(
          title: 'Identifying Your Triggers',
          duration: '4 min',
          content: '''Identifying Your Triggers

To manage anxiety effectively, you first need to understand what sets it off. Triggers are the situations, thoughts, or sensations that activate your anxiety response.

Common Trigger Categories:

Situational Triggers
• Social gatherings or public speaking
• Work deadlines and performance reviews
• Financial worries
• Health concerns
• Conflict or confrontation

Cognitive Triggers
• Catastrophic thinking ("What if the worst happens?")
• Perfectionism ("I can't make any mistakes")
• Comparison ("Everyone else has it together")
• Uncertainty ("I don't know what will happen")

Physical Triggers
• Caffeine and stimulants
• Sleep deprivation
• Hunger or blood sugar drops
• Physical exhaustion

The Trigger Journal

Start keeping a simple log. When you notice anxiety rising, write down:
1. What were you doing?
2. What were you thinking about?
3. Rate the intensity (1-10)
4. What happened right before?

After a week, you'll start seeing patterns. These patterns are your roadmap to targeted coping strategies.

Remember: Identifying triggers isn't about avoiding them forever — it's about preparing yourself to face them with awareness and tools.''',
        ),
        const LessonModel(
          title: 'The Power of Breath',
          duration: '3 min',
          content: '''The Power of Breath

Your breath is the bridge between your conscious and unconscious mind. It's the one autonomic function you can control directly, making it your most accessible anxiety tool.

Why Breathing Works

Slow, deep breathing stimulates the vagus nerve, which activates your parasympathetic nervous system — the "rest and digest" mode. This directly counteracts the fight-or-flight response.

Technique 1: 4-7-8 Breathing
• Inhale through your nose for 4 counts
• Hold your breath for 7 counts
• Exhale through your mouth for 8 counts
• Repeat 4 times

Technique 2: Diaphragmatic Breathing
• Place one hand on your chest, one on your belly
• Breathe so only your belly hand moves
• Inhale for 4 counts, exhale for 6
• Practice for 5 minutes

Make It a Habit

Don't wait for anxiety to practice. Build breathing exercises into your routine:
• Morning: 3 minutes of box breathing before getting up
• Midday: 2 minutes of diaphragmatic breathing after lunch
• Evening: 4-7-8 breathing before sleep

The more you practice when calm, the more automatic it becomes during anxiety.''',
        ),
        const LessonModel(
          title: 'Grounding Techniques',
          duration: '4 min',
          content: '''Grounding Techniques

When anxiety makes you feel disconnected from reality, grounding brings you back. These techniques anchor you to the present moment using your senses and body.

The 5-4-3-2-1 Method
Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste. This engages all your senses and interrupts anxious thought loops.

Physical Grounding
• Press your feet firmly into the floor
• Hold an ice cube in your hand
• Splash cold water on your wrists
• Squeeze a stress ball rhythmically
• Do 10 wall push-ups

Mental Grounding
• Count backwards from 100 by 7s
• Name all the countries you can think of
• Describe your surroundings in detail as if narrating a book
• Pick a color and find everything in sight that matches

Emotional Grounding
• Speak to yourself kindly: "I am safe. This will pass."
• Think of your favorite place and describe it in detail
• Remember a time you felt calm and happy
• Imagine a person who makes you feel safe standing with you

Practice these when you're calm so they become second nature during anxiety.''',
        ),
        const LessonModel(
          title: 'Challenging Anxious Thoughts',
          duration: '5 min',
          content: '''Challenging Anxious Thoughts

Your thoughts are not facts. This is one of the most powerful realizations in managing anxiety. Cognitive restructuring helps you identify and challenge the distorted thinking patterns that fuel anxiety.

Step 1: Catch the Thought
Notice when you're thinking something that makes you anxious. Write it down exactly as it appears in your mind.

Example: "If I speak up in the meeting, everyone will think I'm stupid."

Step 2: Examine the Evidence
Ask yourself:
• What evidence supports this thought?
• What evidence contradicts it?
• Have I been in similar situations before? What actually happened?
• Am I confusing a thought with a fact?

Step 3: Find the Thinking Trap
Common traps include:
• Mind reading: Assuming you know what others think
• Fortune telling: Predicting the worst outcome
• All-or-nothing thinking: Seeing things in black and white
• Catastrophizing: Imagining the worst possible scenario

Step 4: Create a Balanced Thought
Replace the anxious thought with something more realistic:
"I might feel nervous speaking up, but I have valuable ideas. Some people might disagree, and that's normal. Not everyone will judge me negatively."

This isn't about positive thinking — it's about accurate thinking.''',
        ),
      ],
    ),
    CourseModel(
      id: 'course_2',
      title: 'Building Emotional Resilience',
      description:
          'Develop the inner strength to bounce back from life\'s challenges. Explore emotional regulation, building support systems, finding meaning in adversity, and cultivating a resilient mindset.',
      instructor: 'Dr. Marcus Williams',
      lessonCount: 14,
      difficulty: 'Intermediate',
      duration: '~55 min total',
      emoji: '🛡️',
      gradientColors: [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      lessons: [
        const LessonModel(
          title: 'What Is Resilience?',
          duration: '4 min',
          content: '''What Is Resilience?

Resilience is not about being unbreakable. It's about being flexible — bending under pressure without breaking, and springing back when the pressure lifts.

Resilience is a skill, not a trait. You're not born resilient or fragile. Like a muscle, resilience grows stronger with use and practice.

The Four Pillars of Resilience:

1. Connection — Having people you trust and who support you
2. Wellness — Taking care of your physical and mental health
3. Thinking — Maintaining perspective and finding meaning
4. Purpose — Having goals and reasons to move forward

Myths About Resilience:
• Myth: Resilient people don't feel pain → They do. They just process it.
• Myth: You either have it or you don't → It's learnable at any age.
• Myth: Resilience means going it alone → It often means knowing when to ask for help.

This course will help you strengthen each pillar through practical exercises and real strategies.''',
        ),
        const LessonModel(
          title: 'Emotional Awareness',
          duration: '4 min',
          content: '''Emotional Awareness

You can't manage emotions you can't name. Emotional awareness — the ability to identify and understand your emotions — is the foundation of resilience.

The Emotion Wheel

Basic emotions include joy, sadness, anger, fear, surprise, and disgust. But emotions are nuanced. Under "anger," you might actually be feeling frustrated, betrayed, overwhelmed, or disrespected. The more specific you are, the better you can respond.

Body Scanning

Emotions live in your body. Practice this quick scan:
• Where is there tension? (jaw, shoulders, chest?)
• What's your breathing like? (shallow, rapid, held?)
• What's your energy level? (wired, drained, numb?)
• What sensations stand out? (heaviness, butterflies, heat?)

These physical cues are emotional data. Learn to read them.

The Label + Accept Practice

When you notice an emotion:
1. Label it specifically: "I'm feeling disappointed, not just 'bad'"
2. Accept it without judgment: "It makes sense that I feel this way"
3. Ask what it needs: "What would help me right now?"

Naming emotions reduces their intensity. Brain imaging studies show that putting feelings into words decreases activity in the amygdala — your brain's alarm center.''',
        ),
        const LessonModel(
          title: 'Building Your Support Network',
          duration: '3 min',
          content: '''Building Your Support Network

Resilience is not a solo sport. Research consistently shows that social connection is one of the strongest predictors of resilience and overall well-being.

Types of Support You Need:

Emotional Support — Someone who listens without judgment, validates your feelings, and offers empathy.

Practical Support — Someone who helps with tangible needs: a ride, a meal, childcare, or advice.

Informational Support — Someone with knowledge or experience who can guide you through challenges.

Motivational Support — Someone who believes in you, encourages you, and celebrates your wins.

You don't need one person to fill all these roles. Build a diverse support network.

Strengthening Connections:
• Reach out first — don't wait for others
• Be vulnerable — share real feelings, not just updates
• Show up for others — support is reciprocal
• Express appreciation — tell people what they mean to you
• Set boundaries — healthy relationships have them

Remember: Asking for help is a sign of strength, not weakness.''',
        ),
      ],
    ),
    CourseModel(
      id: 'course_3',
      title: 'Sleep Science & Better Rest',
      description:
          'Understand the science of sleep and learn proven strategies for better rest. From sleep hygiene to dealing with racing thoughts at bedtime, this course will transform your relationship with sleep.',
      instructor: 'Dr. Amara Osei',
      lessonCount: 8,
      difficulty: 'Beginner',
      duration: '~30 min total',
      emoji: '🌙',
      gradientColors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      lessons: [
        const LessonModel(
          title: 'Why Sleep Matters',
          duration: '4 min',
          content: '''Why Sleep Matters

Sleep isn't passive downtime — it's one of the most active and critical processes for your brain and body.

What Happens During Sleep:
• Your brain consolidates memories and processes emotions
• Your body repairs tissues and strengthens immune function
• Growth hormones are released
• Toxins accumulated during the day are cleared from the brain
• Neural pathways are strengthened and pruned

The Cost of Poor Sleep:
• Impaired decision-making and creativity
• Increased anxiety and emotional reactivity
• Higher risk of depression
• Weakened immune system
• Reduced ability to cope with stress

Sleep and Mental Health:
The relationship between sleep and mental health is bidirectional. Poor sleep worsens anxiety and depression, and anxiety and depression disrupt sleep. Breaking this cycle is essential.

How Much Do You Need?
Most adults need 7-9 hours of quality sleep. It's not just about quantity — sleep quality matters just as much. Even 8 hours in a noisy, bright room can leave you unrested.

This course will give you the tools to get better, more restorative sleep.''',
        ),
        const LessonModel(
          title: 'Sleep Hygiene Basics',
          duration: '4 min',
          content: '''Sleep Hygiene Basics

Sleep hygiene refers to the habits and environment that promote consistent, high-quality sleep.

Your Sleep Environment:
• Temperature: Keep your bedroom cool (65-68°F / 18-20°C)
• Light: Make it as dark as possible. Consider blackout curtains
• Sound: Use white noise or earplugs if needed
• Bed: Use your bed only for sleep — not scrolling, working, or watching TV

Your Pre-Sleep Routine:
• Set a consistent bedtime and wake time (even weekends)
• Start winding down 60-90 minutes before bed
• Dim lights in your home as bedtime approaches
• Avoid screens 30-60 minutes before sleep
• Try a calming activity: reading, gentle stretching, warm tea

What to Avoid:
• Caffeine after 2 PM
• Alcohol before bed (it disrupts sleep cycles)
• Large meals within 2-3 hours of bedtime
• Intense exercise within 3 hours of bedtime
• Long naps after 3 PM

The 20-Minute Rule:
If you can't fall asleep within 20 minutes, get up. Do something calm and boring in dim light. Return to bed when you feel sleepy. This prevents your brain from associating your bed with wakefulness.''',
        ),
        const LessonModel(
          title: 'Calming Racing Thoughts',
          duration: '3 min',
          content: '''Calming Racing Thoughts at Bedtime

The moment your head hits the pillow, your brain decides to review every embarrassing moment from 2014 and every problem you might face tomorrow. Sound familiar?

Why It Happens:
During the day, your brain is occupied with tasks. At night, without distractions, unprocessed thoughts and emotions demand attention. This is normal, but manageable.

Technique 1: Brain Dump
Keep a notepad by your bed. Before lights out, spend 5 minutes writing down everything on your mind. Worries, tasks, random thoughts — get them out of your head and onto paper.

Technique 2: Progressive Muscle Relaxation
Starting from your toes, tense each muscle group for 5 seconds, then release. Work your way up to your forehead. This redirects your attention from thoughts to body sensations.

Technique 3: The Cognitive Shuffle
Think of a random word (like "morning"). Now for each letter, think of random unconnected things starting with that letter. M-mountain, O-octopus, R-rainbow... This bores your logical brain and promotes sleep.

Technique 4: Guided Imagery
Imagine yourself in a peaceful, detailed scene. A warm beach, a quiet forest, a cozy cabin. Engage all your senses in this imaginary place. What do you see? Hear? Smell? Feel?''',
        ),
      ],
    ),
    CourseModel(
      id: 'course_4',
      title: 'Mindful Mornings',
      description:
          'Transform your morning routine into a foundation for mental wellness. Learn how the first hour of your day sets the tone for everything that follows.',
      instructor: 'Lana Kim',
      lessonCount: 6,
      difficulty: 'Beginner',
      duration: '~20 min total',
      emoji: '🌅',
      gradientColors: [const Color(0xFFfa709a), const Color(0xFFfee140)],
      lessons: [
        const LessonModel(
          title: 'The Power of Morning',
          duration: '3 min',
          content: '''The Power of Morning

How you start your morning shapes your entire day. The first 60 minutes after waking are when your brain is most impressionable, your willpower is highest, and your cortisol levels naturally peak to provide energy and alertness.

The Default Morning vs. The Mindful Morning:

Default: Alarm → phone → scroll → rush → stress → day starts reactive.
Mindful: Alarm → presence → intention → nourishment → day starts proactive.

The Cortisol Awakening Response:
For 30-45 minutes after waking, your cortisol levels naturally rise. This is supposed to give you energy and focus. But when you immediately flood your brain with notifications and stressful information, this healthy cortisol spike becomes anxiety fuel.

The Science:
Studies show that people with consistent morning routines report:
• 25% less stress throughout the day
• Better emotional regulation
• Higher productivity and focus
• Improved sleep quality (yes, mornings affect sleep!)

You don't need to wake at 5 AM or have a 2-hour routine. Even 10 mindful minutes can transform your day.''',
        ),
        const LessonModel(
          title: 'Building Your Ritual',
          duration: '3 min',
          content: '''Building Your Ritual

A morning ritual isn't just a routine — it's an act of self-care. It's you saying, "I matter enough to start my day with intention."

The 10-Minute Mindful Morning:

Minutes 1-3: Gratitude + Intention
Before reaching for your phone, sit up and take three deep breaths. Think of one thing you're grateful for. Set one intention for the day.

Minutes 4-6: Gentle Movement
Stretch your body gently. Roll your neck, reach your arms overhead, twist your spine. Wake your body up with kindness, not urgency.

Minutes 7-9: Mindful Nourishment
Drink a glass of water mindfully. Feel the coolness, taste it. If you have tea or coffee, make it a sensory experience rather than a rushed chore.

Minute 10: One Minute of Stillness
Sit quietly. Close your eyes. Breathe. Just one minute of pure stillness. This is your anchor.

Customizing Your Ritual:
• Journaling (even 3 sentences)
• A short meditation
• Reading something inspiring
• Stepping outside for fresh air
• Gentle yoga or stretching

Start small. Consistency matters more than duration.''',
        ),
      ],
    ),
    CourseModel(
      id: 'course_5',
      title: 'Overcoming Negative Self-Talk',
      description:
          'Break free from the inner critic that holds you back. This course explores the origins of negative self-talk, techniques to interrupt harmful patterns, and practices to build a kinder inner voice.',
      instructor: 'Dr. James Park',
      lessonCount: 12,
      difficulty: 'Intermediate',
      duration: '~50 min total',
      emoji: '💬',
      gradientColors: [const Color(0xFFa18cd1), const Color(0xFFfbc2eb)],
      lessons: [
        const LessonModel(
          title: 'Meet Your Inner Critic',
          duration: '4 min',
          content: '''Meet Your Inner Critic

Everyone has an inner critic — that voice inside your head that says you're not good enough, smart enough, or worthy enough. Understanding this voice is the first step to transforming it.

Where Does It Come From?

Your inner critic isn't random. It developed from:
• Early childhood experiences and messages from caregivers
• Social and cultural expectations
• Past failures, rejections, and embarrassments
• Comparisons with peers and media portrayals

The inner critic originally formed to protect you — to help you avoid rejection, failure, and danger. But it often overgeneralizes and becomes a bully rather than a protector.

Recognizing the Critic:

The inner critic speaks in absolutes: "always," "never," "should," "can't."
• "You always mess things up."
• "You should be further along by now."
• "You can't do anything right."
• "Everyone else has it figured out except you."

The First Step:

Start noticing when your inner critic speaks. Don't try to silence it yet — just observe. When you hear a harsh internal comment, mentally note: "There's the critic again." This creates space between you and the voice, reminding you that the voice is not you.''',
        ),
        const LessonModel(
          title: 'The Cost of Negative Self-Talk',
          duration: '4 min',
          content: '''The Cost of Negative Self-Talk

Negative self-talk isn't just unpleasant — it has real consequences for your mental health, relationships, and life trajectory.

Mental Health Impact:
• Increases anxiety and depression symptoms
• Lowers self-esteem and self-confidence
• Creates learned helplessness ("Why bother trying?")
• Amplifies stress responses
• Contributes to burnout and emotional exhaustion

Physical Impact:
Studies show chronic negative self-talk is associated with:
• Higher cortisol levels (stress hormone)
• Weakened immune function
• Increased inflammation
• Disrupted sleep patterns
• Tension headaches and digestive issues

Behavioral Impact:
• Procrastination (fear of not being good enough)
• Perfectionism (trying to silence the critic by being perfect)
• People-pleasing (seeking external validation)
• Avoidance of challenges and growth opportunities
• Self-sabotage when things start going well

The Cycle:
Negative self-talk → Low confidence → Avoidance or poor performance → More negative self-talk

Breaking this cycle starts with awareness and continues with the techniques you'll learn in the following lessons.''',
        ),
        const LessonModel(
          title: 'Interrupting the Pattern',
          duration: '4 min',
          content: '''Interrupting the Pattern

You've identified your inner critic. Now it's time to learn how to interrupt it before it derails your mood and motivation.

Technique 1: The Name Game
Give your inner critic a name. Something silly or mundane — like "Gary" or "Brenda." When the voice speaks, say internally: "Oh, there's Gary again telling me I'm not good enough." This externalization reduces the critic's power.

Technique 2: The Courtroom Challenge
Treat the critic's statement like a claim in court. Ask:
• What's the evidence FOR this thought?
• What's the evidence AGAINST it?
• Would this hold up in a fair trial?
• What would a fair judge conclude?

Technique 3: The Best Friend Test
If your best friend said "I'm worthless" to you, would you agree? Or would you offer compassion and perspective? Speak to yourself the way you'd speak to them.

Technique 4: The Rubber Band Snap (Metaphorical)
When you catch a harsh self-criticism, visualize snapping a rubber band on your wrist. Then consciously replace the thought with a neutral or compassionate alternative.

The key isn't to eliminate negative thoughts — that's impossible. The key is to develop a faster response time in recognizing and redirecting them.''',
        ),
      ],
    ),
  ];

  // ─── COMMUNITY POSTS ──────────────────────────────────────────
  static List<PostModel> posts = [
    PostModel(
      id: 'post_1',
      username: 'anonstar92',
      flair: PostFlair.anxiety,
      text: 'Does anyone else feel anxious for no reason in the morning? Like I wake up and my heart is already racing. Is this normal? Would love some advice.',
      likes: 47,
      comments: 12,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PostModel(
      id: 'post_2',
      username: 'mindful_mira',
      flair: PostFlair.gratitude,
      text: 'Today I took a 20-minute walk without my phone. It was the most peaceful I\'ve felt in weeks. Highly recommend disconnecting even for a little while. 🌿',
      likes: 134,
      comments: 28,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PostModel(
      id: 'post_3',
      username: 'quietstorm_bd',
      flair: PostFlair.venting,
      text: 'I\'ve been masking my emotions for so long that I don\'t even know how I actually feel anymore. Anyone relate to this? How did you start reconnecting with yourself?',
      likes: 89,
      comments: 41,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    PostModel(
      id: 'post_4',
      username: 'growthseeker',
      flair: PostFlair.personalGrowth,
      text: 'Started journaling 3 weeks ago. I can already see patterns in my thinking I never noticed before. It\'s like having a conversation with yourself you never knew you needed.',
      likes: 212,
      comments: 55,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    PostModel(
      id: 'post_5',
      username: 'zeynep_w',
      flair: PostFlair.adviceNeeded,
      text: 'My therapist suggested EMDR therapy for my trauma. Has anyone tried it? I\'m nervous and would love to hear personal experiences before my first session.',
      likes: 31,
      comments: 19,
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
    ),
    PostModel(
      id: 'post_6',
      username: 'rknight99',
      flair: PostFlair.anxiety,
      text: 'Reminder that you don\'t have to have everything figured out. Uncertainty is uncomfortable but it\'s also where growth lives. You\'re doing better than you think. 💙',
      likes: 387,
      comments: 67,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // ─── SAMPLE COMMENTS ──────────────────────────────────────────
  static List<CommentModel> sampleComments = [
    CommentModel(
      id: 'c1',
      username: 'calm_mind_23',
      text: 'Yes! I experience this too. My therapist says it\'s cortisol surging. Try box breathing right when you wake up — it helps me a lot.',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      likes: 14,
    ),
    CommentModel(
      id: 'c2',
      username: 'hopeful_heart',
      text: 'Morning anxiety is so real. I started keeping a glass of water by my bed and drinking it immediately. Small thing but it helps ground me.',
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      likes: 8,
    ),
    CommentModel(
      id: 'c3',
      username: 'sunflower_mel',
      text: 'You\'re not alone in this. The fact that you\'re asking means you\'re already taking steps 💛',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 22,
    ),
    CommentModel(
      id: 'c4',
      username: 'the_introvert',
      text: 'I\'ve been dealing with this for years. What helped me was not checking my phone for the first 30 minutes. The difference is noticeable.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      likes: 11,
    ),
    CommentModel(
      id: 'c5',
      username: 'wellness_warrior',
      text: 'This is very common. Try naming 3 things you can see as soon as you open your eyes. It interrupts the anxiety cycle.',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      likes: 6,
    ),
  ];
}
