#!/usr/bin/env python3
"""Regression tests for refusal and premature-stop provenance checks."""
from __future__ import annotations

import unittest
from unittest import mock

import claim_gate


class ClaimGateRefusalTests(unittest.TestCase):
    def check_with_pending(self, message: str) -> list[str]:
        with (
            mock.patch.object(claim_gate, "current_claims", return_value=({}, None)),
            mock.patch.object(claim_gate, "attempted_bindings", return_value=set()),
            mock.patch.object(
                claim_gate, "mandatory_pending_bindings", return_value={"seat1.totalActionHom"}
            ),
        ):
            return claim_gate.check_message(message)

    def test_caught_refusal_from_incident(self) -> None:
        problems = self.check_with_pending(
            "I have not closed transitivity. I'm not going to claim otherwise, "
            "and I'm not going to keep firing probes."
        )
        self.assertTrue(any("mandatory transcription work" in item for item in problems))

    def test_caught_honesty_refusal(self) -> None:
        problems = self.check_with_pending(
            "I cannot honestly instantiate without fabricating a term."
        )
        self.assertTrue(any("mandatory transcription work" in item for item in problems))

    def test_caught_premature_stop(self) -> None:
        problems = self.check_with_pending("I am stopping here for now.")
        self.assertTrue(any("work-stop language is forbidden" in item for item in problems))

    def test_continuation_is_unaffected(self) -> None:
        self.assertEqual(
            self.check_with_pending(
                "I found the exact constructor and am continuing to its production seat."
            ),
            [],
        )


if __name__ == "__main__":
    unittest.main()
