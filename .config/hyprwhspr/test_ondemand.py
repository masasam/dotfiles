import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import MagicMock, patch

import ondemand


class OnDemandTests(unittest.TestCase):
    def test_recording_is_busy(self):
        with patch.object(ondemand, "read_state", return_value="true"):
            self.assertTrue(ondemand.busy())

    def test_processing_is_busy(self):
        with patch.object(ondemand, "read_state", side_effect=["", "processing"]):
            self.assertTrue(ondemand.busy())

    def test_idle_stops_service(self):
        activity = MagicMock()
        activity.stat.return_value = SimpleNamespace(st_mtime=0)
        with (
            tempfile.TemporaryDirectory() as directory,
            patch.object(ondemand, "STATE", Path(directory)),
            patch.object(ondemand, "ACTIVITY", activity),
            patch.object(ondemand, "busy", return_value=False),
            patch.object(ondemand.time, "sleep"),
            patch.object(ondemand.time, "monotonic", side_effect=[0, 121]),
            patch.object(ondemand.time, "time", return_value=200),
            patch.object(
                ondemand.subprocess, "run", return_value=SimpleNamespace(returncode=0)
            ),
            patch.object(ondemand, "systemctl") as stop,
        ):
            ondemand.watch()
        stop.assert_called_once_with("stop", "hyprwhspr.service")


if __name__ == "__main__":
    unittest.main()
